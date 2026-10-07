/* Ranks used only on the host: by pdb_generator.c for the orientation and
 * permutation tables, and by pdb_check.c to number all 3,674,160 states.
 */
#ifndef HOST_RANK_H
#define HOST_RANK_H

#include <stdint.h>

#include "cube.h"

/* Orientations of cubies 0..5 as a base-3 number. The last one is implied by
 * the sum being 0 mod 3, so 3^6 = 729 values cover every reachable state.
 */
static uint16_t rank_orient(const state_t *state)
{
    uint16_t rank = 0;
    for (uint8_t i = 0; i < CUBIES - 1; ++i)
        rank = (uint16_t) (rank * 3U + state->o[i]);
    return rank;
}

/* Lehmer code of the permutation: 7! = 5040 values. */
static uint16_t rank_perm(const state_t *state)
{
    uint16_t rank = 0;
    for (uint8_t i = 0; i < CUBIES - 1; ++i) {
        uint8_t smaller = 0;
        for (uint8_t j = (uint8_t) (i + 1); j < CUBIES; ++j)
            smaller = (uint8_t) (smaller + (state->p[j] < state->p[i]));
        rank = (uint16_t) (rank * (CUBIES - i) + smaller);
    }
    return rank;
}

#endif /* HOST_RANK_H */
