/* Host-side generator for the pattern databases used by my_solver.c.
 *
 * Each table is a breadth-first search from solved over a relaxed problem:
 * the orientation table ignores where cubies are, the permutation table
 * ignores how they are twisted, and the R-face table ignores the three cubies
 * off the R face. The result is written as C arrays to stdout:
 *
 *     ./pdb_generator > pdb.h
 *
 * Statistics (entries, max, distribution) go to stderr.
 */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "cube.h"
#include "host_rank.h"

enum {
    ORIENT_SIZE = 729,   /* 3^6 */
    PERM_SIZE = 5040,    /* 7! */
    R_FACE_SIZE = 68040, /* 7 * 6 * 5 * 4 * 3^4 */
    UNSEEN = 0xFF,
};

/* Inverse of rank_orient, with cubies left in their home positions. */
static state_t unrank_orient(uint32_t rank)
{
    state_t state;
    uint8_t sum = 0;
    for (int i = CUBIES - 2; i >= 0; --i) {
        state.o[i] = (uint8_t) (rank % 3U);
        rank /= 3U;
        sum = (uint8_t) (sum + state.o[i]);
    }
    state.o[CUBIES - 1] = (uint8_t) ((3U - sum % 3U) % 3U);
    for (uint8_t i = 0; i < CUBIES; ++i)
        state.p[i] = i;
    return state;
}

/* Inverse of rank_perm, with every cubie untwisted. */
static state_t unrank_perm(uint32_t rank)
{
    state_t state;
    uint8_t digit[CUBIES], used[CUBIES] = {0};
    for (int i = CUBIES - 1; i >= 0; --i) {
        digit[i] = (uint8_t) (rank % (uint32_t) (CUBIES - i));
        rank /= (uint32_t) (CUBIES - i);
    }
    for (uint8_t i = 0; i < CUBIES; ++i) {
        /* Take the digit[i]-th smallest value not used yet. */
        uint8_t k = digit[i], v;
        for (v = 0;; ++v) {
            if (used[v])
                continue;
            if (k == 0)
                break;
            --k;
        }
        used[v] = 1;
        state.p[i] = v;
        state.o[i] = 0;
    }
    return state;
}

/* Inverse of rank_r_face. The other three cubies fill the free positions in
 * any order, untwisted: the R-face rank never looks at them.
 */
static state_t unrank_r_face(uint32_t rank)
{
    static const uint8_t others[3] = {2, 5, 6};
    state_t state;
    uint8_t place[4], turned[4], used[CUBIES] = {0};
    for (int k = 3; k >= 0; --k) {
        turned[k] = (uint8_t) (rank % 3U);
        rank /= 3U;
    }
    for (int k = 3; k >= 0; --k) {
        place[k] = (uint8_t) (rank % (uint32_t) (CUBIES - k));
        rank /= (uint32_t) (CUBIES - k);
    }
    for (uint8_t k = 0; k < 4; ++k) {
        /* Take the place[k]-th smallest position not used yet. */
        uint8_t n = place[k], pos;
        for (pos = 0;; ++pos) {
            if (used[pos])
                continue;
            if (n == 0)
                break;
            --n;
        }
        used[pos] = 1;
        state.p[pos] = r_cubies[k];
        state.o[pos] = turned[k];
    }
    uint8_t next = 0;
    for (uint8_t pos = 0; pos < CUBIES; ++pos)
        if (!used[pos]) {
            state.p[pos] = others[next++];
            state.o[pos] = 0;
        }
    return state;
}

/* Widen the target-side ranks to one signature for build(). */
static uint32_t rank_orient32(const state_t *state)
{
    return rank_orient(state);
}

static uint32_t rank_perm32(const state_t *state)
{
    return rank_perm(state);
}

/* BFS over `size` abstract states. unrank builds a representative full state,
 * rank projects a full state back, so a move on the representative gives the
 * same abstract neighbour whichever representative is chosen.
 */
static void build(uint8_t *table, uint32_t size, state_t (*unrank)(uint32_t),
                  uint32_t (*rank)(const state_t *))
{
    static uint32_t queue[R_FACE_SIZE];
    uint32_t head = 0, tail = 0;
    state_t solved;
    for (uint8_t i = 0; i < CUBIES; ++i)
        solved.p[i] = i, solved.o[i] = 0;
    /* The solved state is not always index 0, e.g. for the R-face rank. */
    uint32_t start = rank(&solved);

    memset(table, UNSEEN, size);
    table[start] = 0;
    queue[tail++] = start;
    while (head < tail) {
        uint32_t cur = queue[head++];
        state_t state = unrank(cur);
        for (uint8_t move = 0; move < MOVES; ++move) {
            state_t child = apply_move(state, move);
            uint32_t idx = rank(&child);
            if (table[idx] == UNSEEN) {
                table[idx] = (uint8_t) (table[cur] + 1);
                queue[tail++] = idx;
            }
        }
    }
}

static int report(const char *name, const uint8_t *table, uint32_t size)
{
    unsigned long count[16] = {0};
    uint8_t max = 0;
    unsigned long sum = 0;
    for (uint32_t i = 0; i < size; ++i) {
        if (table[i] == UNSEEN) {
            fprintf(stderr, "%s: entry %lu unreachable\n", name,
                    (unsigned long) i);
            return 0;
        }
        ++count[table[i]];
        sum += table[i];
        if (table[i] > max)
            max = table[i];
    }
    fprintf(stderr, "%s: %lu entries, max %u, mean %.3f\n", name,
            (unsigned long) size, max, (double) sum / size);
    for (uint8_t d = 0; d <= max; ++d)
        fprintf(stderr, "  h=%u: %lu\n", d, count[d]);
    return 1;
}

static void emit(const char *name, const uint8_t *table, uint32_t size)
{
    printf("static const uint8_t %s[%lu] = {", name, (unsigned long) size);
    for (uint32_t i = 0; i < size; ++i)
        printf("%s%u,", i % 24 ? " " : "\n    ", table[i]);
    printf("\n};\n");
}

int main(void)
{
    static uint8_t orient[ORIENT_SIZE], perm[PERM_SIZE], r_face[R_FACE_SIZE];

    build(orient, ORIENT_SIZE, unrank_orient, rank_orient32);
    build(perm, PERM_SIZE, unrank_perm, rank_perm32);
    build(r_face, R_FACE_SIZE, unrank_r_face, rank_r_face);
    if (!report("pdb_orient", orient, ORIENT_SIZE) ||
        !report("pdb_perm", perm, PERM_SIZE) ||
        !report("pdb_r_face", r_face, R_FACE_SIZE))
        return 1;

    printf("/* Generated by pdb_generator.c. Do not edit. */\n");
    printf("#ifndef PDB_H\n#define PDB_H\n\n#include <stdint.h>\n\n");
    emit("pdb_orient", orient, ORIENT_SIZE);
    printf("\n");
    emit("pdb_perm", perm, PERM_SIZE);
    printf("\n");
    emit("pdb_r_face", r_face, R_FACE_SIZE);
    printf("\n#endif /* PDB_H */\n");
    return 0;
}
