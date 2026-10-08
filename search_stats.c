/* Counts what the search does for one state, on the host.
 *
 * dls() is copied from search.h with counters added and the cutoff split per
 * table; the search order and the nodes expanded are unchanged, so the node
 * count must match my_solver.
 *
 * Usage: search_stats [PPPPPPPOOOOOOO]    (default 54721631111111)
 */
#include <stdio.h>
#include <string.h>

#include "search.h"

static unsigned long iterations, pops, goal_tests, expanded;
static unsigned long cuts_orient, cuts_perm, cuts_r_face; /* each table alone */

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
        /* Same cutoff as heuristic(): max of the three exceeds t iff at least
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

int main(int argc, char **argv)
{
    const char *input = argc > 1 ? argv[1] : "54721631111111";
    state_t state;
    uint8_t path[MAX_DEPTH];

    if (strlen(input) != 14) {
        fprintf(stderr, "usage: %s [PPPPPPPOOOOOOO]\n", argv[0]);
        return 2;
    }
    for (int i = 0; i < CUBIES; ++i) {
        state.p[i] = (uint8_t) (input[i] - '1');
        state.o[i] = (uint8_t) (input[CUBIES + i] - '1');
    }

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
    return 0;
}
