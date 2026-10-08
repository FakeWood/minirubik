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
    uint8_t hr = pdb_r_face[rank_r_face(state)];
    uint8_t h = ho > hp ? ho : hp;
    return h > hr ? h : hr;
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
static int dls(const state_t *start, int limit, uint8_t path[MAX_DEPTH])
{
    state_t stack[MAX_DEPTH + 1];
    uint8_t next[MAX_DEPTH + 1];
    /* skip[d]: first move of the face turned at depth d - 1. Turning the same
     * face twice in a row cancels or merges into one move, so that face's
     * three moves are jumped over at once. MOVES at the root skips nothing.
     */
    uint8_t skip[MAX_DEPTH + 1];
    int depth = 0;

    /* Field by field rather than a struct copy, which may become memcpy. */
    for (uint8_t i = 0; i < CUBIES; ++i) {
        stack[0].p[i] = start->p[i];
        stack[0].o[i] = start->o[i];
    }
    next[0] = 0;
    skip[0] = MOVES;
    while (depth >= 0) {
        if (depth == limit) {
            if (is_solved(&stack[depth]))
                return 1;
            --depth;
            continue;
        }
        uint8_t move = next[depth];
        if (move == skip[depth])
            move = (uint8_t) (move + 3);
        if (move >= MOVES) {
            --depth;
            continue;
        }
        next[depth] = (uint8_t) (move + 1);
        ++nodes;
        path[depth] = move;
        apply_move(&stack[depth + 1], &stack[depth], move);
        /* IDA* cutoff: the child cannot reach solved within the limit. */
        if (depth + 1 + heuristic(&stack[depth + 1]) > limit)
            continue;
        ++depth;
        next[depth] = 0;
        skip[depth] = face_start[move];
    }
    return 0;
}

/* Iterative deepening: try limits 0, 1, ..., MAX_DEPTH. The first limit that
 * succeeds is the shortest solution length, so the result is optimal.
 */
static int iddfs(const state_t *start, uint8_t path[MAX_DEPTH])
{
    for (int limit = 0; limit <= MAX_DEPTH; ++limit)
        if (dls(start, limit, path))
            return limit;
    return -1;
}

#endif /* SEARCH_H */
