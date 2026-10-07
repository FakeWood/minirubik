/* Cube model shared by my_solver.c and pdb_generator.c. */
#ifndef CUBE_H
#define CUBE_H

#include <stdint.h>

enum {
    CUBIES = 7,
    MOVES = 9,
    MAX_DEPTH = 11, /* HTM diameter: no state needs more moves */
};

typedef struct {
    uint8_t p[CUBIES], o[CUBIES];
} state_t;

/* Each destination takes a cubie from source[face][destination]. */
static const uint8_t source[3][CUBIES] = {
    {1, 4, 2, 0, 3, 5, 6},
    {0, 1, 2, 4, 5, 6, 3},
    {0, 2, 5, 3, 1, 4, 6},
};
static const uint8_t twist[3][CUBIES] = {
    {1, 2, 0, 2, 1, 0, 0},
    {0, 0, 0, 1, 2, 1, 2},
    {0, 0, 0, 0, 0, 0, 0},
};

static state_t quarter_turn(state_t state, uint8_t face)
{
    state_t result;
    for (uint8_t i = 0; i < CUBIES; ++i) {
        uint8_t from = source[face][i];
        result.p[i] = state.p[from];
        result.o[i] = (uint8_t) ((state.o[from] + twist[face][i]) % 3U);
    }
    return result;
}

static state_t apply_move(state_t state, uint8_t move)
{
    uint8_t turns = (uint8_t) (move % 3U + 1U);
    for (uint8_t i = 0; i < turns; ++i)
        state = quarter_turn(state, (uint8_t) (move / 3U));
    return state;
}

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

/* The cubies that sit on the R face when solved; R cycles exactly these. */
static const uint8_t r_cubies[4] = {0, 1, 3, 4};

/* Positions and twists of the four R-face cubies, ignoring the other three:
 * 7 * 6 * 5 * 4 = 840 placements times 3^4 = 81 twists = 68,040 values.
 *
 * The rank is place * 81 + turned, both mixed-radix numbers with r_cubies[0]
 * as the most significant digit:
 *
 *     place  = ((d0 * 6 + d1) * 5 + d2) * 4 + d3    digit dk < 7 - k
 *     turned = ((t0 * 3 + t1) * 3 + t2) * 3 + t3    digit tk < 3
 *
 * dk is the position of r_cubies[k] counted among the positions not taken by
 * r_cubies[0..k-1], so four distinct positions use all 840 values and no
 * value is wasted on two cubies sharing a position. tk is its twist. The
 * other three cubies contribute no digit at all. Unranking peels digits off
 * from the least significant end: t3..t0 first, then d3..d0.
 */
static uint32_t rank_r_face(const state_t *state)
{
    /* where[cubie] = position, the inverse of p[position] = cubie. */
    uint8_t where[CUBIES];
    for (uint8_t i = 0; i < CUBIES; ++i)
        where[state->p[i]] = i;

    uint32_t place = 0, turned = 0;
    for (uint8_t k = 0; k < 4; ++k) {
        uint8_t pos = where[r_cubies[k]];
        /* dk = pos minus the earlier tracked cubies sitting below it, i.e.
         * the number of still-free positions below pos.
         */
        uint8_t skip = 0;
        for (uint8_t j = 0; j < k; ++j)
            skip = (uint8_t) (skip + (where[r_cubies[j]] < pos));
        place = place * (CUBIES - k) + (uint32_t) (pos - skip);
        turned = turned * 3U + state->o[pos];
    }
    return place * 81U + turned;
}

#endif /* CUBE_H */
