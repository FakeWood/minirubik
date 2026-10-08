/* Counts what the search does for one state, on the host.
 *
 * dls() is copied from search.h with counters added and the cutoff split per
 * table; the search order and the nodes expanded are unchanged, so the node
 * count must match my_solver.
 *
 * It also prints, for each order of the three tables in a lazy cutoff that
 * stops at the first table above the threshold, how many times each rank
 * would be computed. Given the cost per rank call (from bench.sh), it prints
 * the rank cost per node of each order too.
 *
 * Usage: search_stats [PPPPPPPOOOOOOO [COST_ORIENT COST_PERM COST_R_FACE]]
 *        (default state 54721631111111)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "search.h"

static unsigned long iterations, pops, goal_tests, expanded;
static unsigned long cuts_orient, cuts_perm, cuts_r_face; /* each table alone */
/* by_cut[mask]: nodes whose set of cutting tables is mask, with bit 0 for
 * orient, bit 1 for perm and bit 2 for r_face.
 */
static unsigned long by_cut[8];

static int dls_stats(const state_t *start, int limit, uint8_t path[MAX_DEPTH])
{
    state_t stack[MAX_DEPTH + 1];
    uint8_t next[MAX_DEPTH + 1];
    uint8_t skip[MAX_DEPTH + 1];
    int depth = 0;

    stack[0] = *start;
    next[0] = 0;
    skip[0] = MOVES;
    while (depth >= 0) {
        ++iterations;
        if (depth == limit) {
            ++goal_tests;
            if (is_solved(&stack[depth]))
                return 1;
            --depth;
            continue;
        }
        uint8_t move = next[depth];
        if (move == skip[depth])
            move = (uint8_t) (move + 3);
        if (move >= MOVES) {
            ++pops;
            --depth;
            continue;
        }
        next[depth] = (uint8_t) (move + 1);
        ++nodes;
        path[depth] = move;
        apply_move(&stack[depth + 1], &stack[depth], move);
        /* Same cutoff as exceeds(): max of the three exceeds t iff at least
         * one of them does.
         */
        const state_t *child = &stack[depth + 1];
        int t = limit - depth - 1;
        int o = pdb_orient[rank_orient(child)] > t;
        int p = pdb_perm[rank_perm(child)] > t;
        int r = pdb_r_face[rank_r_face(child)] > t;
        cuts_orient += (unsigned long) o;
        cuts_perm += (unsigned long) p;
        cuts_r_face += (unsigned long) r;
        ++by_cut[o | p << 1 | r << 2];
        if (o || p || r)
            continue;
        ++expanded;
        ++depth;
        next[depth] = 0;
        skip[depth] = face_start[move];
    }
    return 0;
}

static double pct(unsigned long part)
{
    return 100.0 * (double) part / (double) nodes;
}

/* Nodes not cut by any table in mask, i.e. that reach the next table.
 *
 * mask uses the bits of by_cut[] for the tables already looked up. m & mask
 * is the set of those tables that would cut class m: if it is non-empty, the
 * nodes of class m were already cut and never get further. For example, with
 * only perm looked up (mask = 2), classes 0, 1, 4 and 5 (no perm bit) reach
 * the next table.
 */
static unsigned long survive(unsigned mask)
{
    unsigned long n = 0;
    for (unsigned m = 0; m < 8; ++m)
        if (!(m & mask)) /* no table looked up so far cuts class m */
            n += by_cut[m];
    return n;
}

/* For each of the 6 orders of the tables, how many times each rank runs when
 * the cutoff stops at the first table above the threshold. Whether a node is
 * cut does not depend on the order, only how many ranks it takes, so these
 * counts are exact, derived from one search rather than six. With cost (one
 * number per table, indexed like the bits of by_cut[]), also print the
 * average rank cost per node.
 */
static void print_orders(const double *cost)
{
    static const char *const name[3] = {"orient", "perm", "r_face"};
    /* Table indices, i.e. bit numbers in by_cut[], first to last. */
    static const unsigned order[6][3] = {
        {0, 1, 2}, {0, 2, 1}, {1, 0, 2}, {1, 2, 0}, {2, 0, 1}, {2, 1, 0},
    };
    printf("\nlazy order               rank calls: 1st      2nd      3rd");
    printf(cost ? "   rank cost per node\n" : "\n");
    for (int k = 0; k < 6; ++k) {
        const unsigned *ord = order[k];
        /* Every node ranks the 1st table; only the nodes the tables before
         * it did not cut rank the 2nd and the 3rd.
         */
        unsigned long calls[3] = {
            nodes,
            survive(1U << ord[0]),
            survive(1U << ord[0] | 1U << ord[1]),
        };
        printf("%-7s %-7s %-7s %16lu %8lu %8lu", name[ord[0]], name[ord[1]],
               name[ord[2]], calls[0], calls[1], calls[2]);
        if (cost) {
            /* Sum of calls times cost per call, over the three tables. */
            double total = 0;
            for (int i = 0; i < 3; ++i)
                total += (double) calls[i] * cost[ord[i]];
            printf("   %18.1f", total / (double) nodes);
        }
        putchar('\n');
    }
}

int main(int argc, char **argv)
{
    const char *input = argc > 1 ? argv[1] : "54721631111111";
    state_t state;
    uint8_t path[MAX_DEPTH];

    double cost[3];
    int have_cost = argc == 5;
    if (strlen(input) != 14 || (argc > 2 && !have_cost)) {
        fprintf(stderr,
                "usage: %s [PPPPPPPOOOOOOO [COST_ORIENT COST_PERM "
                "COST_R_FACE]]\n",
                argv[0]);
        return 2;
    }
    for (int i = 0; i < CUBIES; ++i) {
        state.p[i] = (uint8_t) (input[i] - '1');
        state.o[i] = (uint8_t) (input[CUBIES + i] - '1');
    }
    for (int i = 0; have_cost && i < 3; ++i)
        cost[i] = atof(argv[2 + i]);

    (void) iddfs; /* replaced by the loop below */
    int length = -1;
    for (int limit = 0; limit <= MAX_DEPTH && length < 0; ++limit)
        if (dls_stats(&state, limit, path))
            length = limit;

    printf("state %s, length %d\n", input, length);
    printf("loop iterations  %lu\n", iterations);
    printf("nodes            %lu\n", nodes);
    printf("pops             %lu\n", pops);
    printf("goal tests       %lu\n", goal_tests);
    printf("cut by orient    %lu (%.0f%%)\n", cuts_orient, pct(cuts_orient));
    printf("cut by perm      %lu (%.0f%%)\n", cuts_perm, pct(cuts_perm));
    printf("cut by r_face    %lu (%.0f%%)\n", cuts_r_face, pct(cuts_r_face));
    printf("expanded         %lu (%.0f%%)\n", expanded, pct(expanded));
    print_orders(have_cost ? cost : NULL);
    return 0;
}
