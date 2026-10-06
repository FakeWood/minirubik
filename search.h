/* IDA* search shared by my_solver.c and pdb_check.c. */
#ifndef SEARCH_H
#define SEARCH_H

#include <stdint.h>

#include "cube.h"
#include "pdb.h"

/* Admissible lower bound: each table is an exact distance in a relaxed
 * problem, so neither exceeds the real distance, and neither does their max.
 */
static uint8_t heuristic(const state_t *state)
{
    uint8_t ho = pdb_orient[rank_orient(state)];
    uint8_t hp = pdb_perm[rank_perm(state)];
    return ho > hp ? ho : hp;
}

static int is_solved(const state_t *state)
{
    for (uint8_t i = 0; i < CUBIES; ++i)
        if (state->p[i] != i || state->o[i] != 0)
            return 0;
    return 1;
}

static unsigned long nodes; /* expanded nodes, for measurement */

/* Depth-limited DFS without recursion: an explicit stack of states and the
 * next move to try at each depth. Returns 1 if a solution of exactly `limit`
 * moves exists (stored in path), 0 otherwise.
 */
static int dls(state_t start, int limit, uint8_t path[MAX_DEPTH])
{
    state_t stack[MAX_DEPTH + 1];
    uint8_t next[MAX_DEPTH + 1];
    int depth = 0;

    stack[0] = start;
    next[0] = 0;
    while (depth >= 0) {
        if (depth == limit) {
            if (is_solved(&stack[depth]))
                return 1;
            --depth;
            continue;
        }
        if (next[depth] == MOVES) {
            --depth;
            continue;
        }
        uint8_t move = next[depth]++;
        /* Same face twice in a row cancels or merges into one move. */
        if (depth > 0 && move / 3U == path[depth - 1] / 3U)
            continue;
        ++nodes;
        path[depth] = move;
        stack[depth + 1] = apply_move(stack[depth], move);
        /* IDA* cutoff: the child cannot reach solved within the limit. */
        if (depth + 1 + heuristic(&stack[depth + 1]) > limit)
            continue;
        next[++depth] = 0;
    }
    return 0;
}

/* Iterative deepening: try limits 0, 1, ..., MAX_DEPTH. The first limit that
 * succeeds is the shortest solution length, so the result is optimal.
 */
static int iddfs(state_t start, uint8_t path[MAX_DEPTH])
{
    for (int limit = 0; limit <= MAX_DEPTH; ++limit)
        if (dls(start, limit, path))
            return limit;
    return -1;
}

#endif /* SEARCH_H */
