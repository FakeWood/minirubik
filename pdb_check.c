/* Host-side checker for the IDA* solver. Not shipped to the target.
 *
 * 1. Full BFS from solved gives the true distance d(s) of all 3,674,160
 *    states (a host-only oracle; the target never sees this table).
 * 2. H1: h(s) <= d(s) for every state, plus how tight h is.
 * 3. H2: every pattern database entry is the exact distance of its abstract
 *    state: the smallest d(s) over the full states s that map to it. This
 *    also shows every entry is populated, the solved entry is 0 and the
 *    maximum is right, all against the oracle rather than pdb_generator.c.
 * 4. Every distance-11 state is solved with IDA*: the solution must have 11
 *    moves and reach solved, and the node counts are summarised.
 *
 * With --all, step 4 runs on every state instead (H3, slow).
 */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cube.h"
#include "search.h"

enum {
    ORIENTS = 729,
    STATES = 5040 * ORIENTS,
    UNSEEN = 0xFF,
};

static uint32_t rank_state(const state_t *state)
{
    return (uint32_t) rank_perm(state) * ORIENTS + rank_orient(state);
}

/* The full h the solver's cutoff (move_and_cut in search.h) is based on: the max
 * of the three tables. Each is an exact distance in a relaxed problem, so
 * neither exceeds the real distance, and neither does their max.
 */
static uint8_t heuristic(const state_t *state)
{
    uint8_t ho = pdb_orient[rank_orient(state)];
    uint8_t hp = pdb_perm[rank_perm(state)];
    uint8_t hr = pdb_r_face[rank_r_face(state)];
    uint8_t h = ho > hp ? ho : hp;
    return h > hr ? h : hr;
}

/* Widen the ranks to one signature for check_table(). */
static uint32_t rank_orient32(const state_t *state)
{
    return rank_orient(state);
}

static uint32_t rank_perm32(const state_t *state)
{
    return rank_perm(state);
}

/* H2 for one table. Each table is a BFS over the abstract states that
 * `rank` projects onto, and a move acts on an abstract state the same way
 * whichever full state stands for it. So an abstract state's distance is the
 * fewest moves to any full state mapping to it: the minimum of d(s) over
 * them, taken here from the oracle.
 */
static int check_table(const char *name, const uint8_t *table, uint32_t size,
                       uint32_t (*rank)(const state_t *),
                       const state_t *states, const uint8_t *dist,
                       uint32_t count)
{
    uint8_t *want = malloc(size);
    if (!want) {
        fputs("out of memory\n", stderr);
        return 0;
    }
    memset(want, UNSEEN, size);
    for (uint32_t i = 0; i < count; ++i) {
        uint32_t idx = rank(&states[i]);
        uint8_t d = dist[rank_state(&states[i])];
        if (d < want[idx])
            want[idx] = d;
    }

    state_t solved;
    for (uint8_t i = 0; i < CUBIES; ++i)
        solved.p[i] = i, solved.o[i] = 0;
    uint32_t start = rank(&solved);

    int ok = 1;
    uint32_t unreached = 0, wrong = 0, zeros = 0;
    uint8_t max = 0, want_max = 0;
    for (uint32_t i = 0; i < size; ++i) {
        if (want[i] == UNSEEN)
            ++unreached; /* no full state maps here: a rank gap */
        else if (want[i] > want_max)
            want_max = want[i];
        if (table[i] != want[i]) {
            if (!wrong)
                fprintf(stderr, "H2 FAIL: %s[%lu] = %u, oracle %u\n", name,
                        (unsigned long) i, table[i], want[i]);
            ++wrong;
        }
        if (table[i] == 0)
            ++zeros;
        if (table[i] > max)
            max = table[i];
    }
    if (unreached || wrong || table[start] != 0 || zeros != 1 ||
        max != want_max)
        ok = 0;
    printf("H2 %s: %lu entries, %lu unreached, %lu differ from the oracle, "
           "solved entry [%lu] = %u, %lu zero, max %u (oracle %u): %s\n",
           name, (unsigned long) size, (unsigned long) unreached,
           (unsigned long) wrong, (unsigned long) start, table[start],
           (unsigned long) zeros, max, want_max, ok ? "ok" : "FAIL");
    free(want);
    return ok;
}

static void print_state(FILE *out, const state_t *state)
{
    for (uint8_t i = 0; i < CUBIES; ++i)
        fputc('1' + state->p[i], out);
    for (uint8_t i = 0; i < CUBIES; ++i)
        fputc('1' + state->o[i], out);
}

static int cmp_ulong(const void *a, const void *b)
{
    unsigned long x = *(const unsigned long *) a;
    unsigned long y = *(const unsigned long *) b;
    return (x > y) - (x < y);
}

/* Solve one state and check length and result against the oracle. */
static int check_solve(const state_t *state, uint8_t want, unsigned long *cost)
{
    uint8_t path[MAX_DEPTH];
    nodes = 0;
    int length = iddfs(state, path);
    *cost = nodes;
    state_t s = *state, t;
    for (int i = 0; i < length; ++i) {
        apply_move(&t, &s, path[i]);
        s = t;
    }
    if (length != want || !is_solved(&s)) {
        fputs("FAIL: ", stderr);
        print_state(stderr, state);
        fprintf(stderr, " expected %u moves, got %d%s\n", want, length,
                is_solved(&s) ? "" : " (does not solve)");
        return 0;
    }
    return 1;
}

int main(int argc, char **argv)
{
    int all = argc > 1 && !strcmp(argv[1], "--all");
    uint8_t *dist = malloc(STATES);
    state_t *queue = malloc(sizeof(state_t) * STATES);
    if (!dist || !queue) {
        fputs("out of memory\n", stderr);
        return 1;
    }

    /* 1. Oracle BFS. */
    memset(dist, UNSEEN, STATES);
    uint32_t head = 0, tail = 0;
    for (uint8_t i = 0; i < CUBIES; ++i)
        queue[0].p[i] = i, queue[0].o[i] = 0;
    dist[rank_state(&queue[0])] = 0;
    tail = 1;
    while (head < tail) {
        state_t cur = queue[head++];
        uint8_t d = dist[rank_state(&cur)];
        for (uint8_t move = 0; move < MOVES; ++move) {
            state_t child;
            apply_move(&child, &cur, move);
            uint32_t idx = rank_state(&child);
            if (dist[idx] == UNSEEN) {
                dist[idx] = (uint8_t) (d + 1);
                queue[tail++] = child;
            }
        }
    }
    unsigned per_depth[MAX_DEPTH + 1] = {0};
    for (uint32_t i = 0; i < tail; ++i)
        ++per_depth[dist[rank_state(&queue[i])]];
    printf("BFS reached %u of %u states\n", tail, (unsigned) STATES);
    for (int d = 0; d <= MAX_DEPTH; ++d)
        printf("  d=%2d: %u\n", d, per_depth[d]);

    /* 2. H1: admissibility, and the gap d - h. */
    unsigned long gap_sum = 0, gap_hist[MAX_DEPTH + 1] = {0};
    int admissible = 1;
    for (uint32_t i = 0; i < tail; ++i) {
        uint8_t d = dist[rank_state(&queue[i])];
        uint8_t h = heuristic(&queue[i]);
        if (h > d) {
            if (admissible) {
                fputs("H1 FAIL: ", stderr);
                print_state(stderr, &queue[i]);
                fprintf(stderr, " h=%u > d=%u\n", h, d);
            }
            admissible = 0;
            continue;
        }
        gap_sum += d - h;
        ++gap_hist[d - h];
    }
    printf("H1 admissible: %s, mean d-h %.3f\n", admissible ? "yes" : "NO",
           (double) gap_sum / tail);
    for (int g = 0; g <= MAX_DEPTH; ++g)
        if (gap_hist[g])
            printf("  d-h=%d: %lu\n", g, gap_hist[g]);

    /* 3. H2: every table entry against the oracle. */
    int tables = check_table("pdb_orient", pdb_orient, 729, rank_orient32,
                             queue, dist, tail);
    tables &= check_table("pdb_perm", pdb_perm, 5040, rank_perm32, queue,
                          dist, tail);
    tables &= check_table("pdb_r_face", pdb_r_face, 68040, rank_r_face, queue,
                          dist, tail);

    /* 4. Solve distance-11 states (or all states with --all). */
    unsigned count = all ? tail : per_depth[MAX_DEPTH];
    unsigned long *cost = malloc(sizeof(unsigned long) * count);
    if (!cost) {
        fputs("out of memory\n", stderr);
        return 1;
    }
    unsigned n = 0, failures = 0;
    uint32_t worst = 0; /* queue index of the most expensive state */
    unsigned long total = 0, worst_cost = 0;
    for (uint32_t i = 0; i < tail; ++i) {
        uint8_t d = dist[rank_state(&queue[i])];
        if (!all && d != MAX_DEPTH)
            continue;
        if (!check_solve(&queue[i], d, &cost[n]))
            ++failures;
        total += cost[n];
        if (cost[n] > worst_cost)
            worst_cost = cost[n], worst = i;
        ++n;
    }
    qsort(cost, n, sizeof(cost[0]), cmp_ulong);
    printf("Solved %u %s states, %u failures\n", n,
           all ? "(all)" : "distance-11", failures);
    printf("  nodes: min %lu, median %lu, mean %.0f, p99 %lu, max %lu\n",
           cost[0], cost[n / 2], (double) total / n, cost[n * 99 / 100],
           cost[n - 1]);
    printf("  worst state: ");
    print_state(stdout, &queue[worst]);
    printf(" (d=%u)\n", dist[rank_state(&queue[worst])]);

    free(cost);
    free(queue);
    free(dist);
    return failures != 0 || !admissible || !tables;
}
