/* Host-side checker for the IDA* solver. Not shipped to the target.
 *
 * 1. Full BFS from solved gives the true distance d(s) of all 3,674,160
 *    states (a host-only oracle; the target never sees this table).
 * 2. H1: h(s) <= d(s) for every state, plus how tight h is.
 * 3. Every distance-11 state is solved with IDA*: the solution must have 11
 *    moves and reach solved, and the node counts are summarised.
 *
 * With --all, step 3 runs on every state instead (H3, slow).
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
    int length = iddfs(*state, path);
    *cost = nodes;
    state_t s = *state;
    for (int i = 0; i < length; ++i)
        s = apply_move(s, path[i]);
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
            state_t child = apply_move(cur, move);
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

    /* 3. Solve distance-11 states (or all states with --all). */
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
    return failures != 0 || !admissible;
}
