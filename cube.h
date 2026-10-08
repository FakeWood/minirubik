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

/* Each destination takes a cubie from source[move][destination] and adds
 * twist[move][destination] to its orientation. Moves are R R2 R' B B2 B' D D2
 * D', and each row is its face's quarter turn composed 1, 2 or 3 times, so a
 * move is one pass over the cubies however many quarter turns it stands for.
 */
static const uint8_t source[MOVES][CUBIES] = {
    {1, 4, 2, 0, 3, 5, 6}, {4, 3, 2, 1, 0, 5, 6}, {3, 0, 2, 4, 1, 5, 6},
    {0, 1, 2, 4, 5, 6, 3}, {0, 1, 2, 5, 6, 3, 4}, {0, 1, 2, 6, 3, 4, 5},
    {0, 2, 5, 3, 1, 4, 6}, {0, 5, 4, 3, 2, 1, 6}, {0, 4, 1, 3, 5, 2, 6},
};
static const uint8_t twist[MOVES][CUBIES] = {
    {1, 2, 0, 2, 1, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {1, 2, 0, 2, 1, 0, 0},
    {0, 0, 0, 1, 2, 1, 2}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 1, 2, 1, 2},
    {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0},
};

/* First move of the face each move turns, for skipping a whole face. */
static const uint8_t face_start[MOVES] = {0, 0, 0, 3, 3, 3, 6, 6, 6};

static void apply_move(state_t *out, const state_t *in, uint8_t move)
{
    const uint8_t *src = source[move], *tw = twist[move];
    for (uint8_t i = 0; i < CUBIES; ++i) {
        uint8_t from = src[i];
        /* Both terms are below 3, so the sum is below 6 and one conditional
         * subtract replaces % 3: sltiu, neg, andi, sub, and no branch.
         */
        uint32_t o = (uint32_t) in->o[from] + tw[i];
        out->p[i] = in->p[from];
        out->o[i] = (uint8_t) (o - (3U & -(uint32_t) (o >= 3U)));
    }
}

/* Orientations of cubies 0..5 as a base-3 number. The last one is implied by
 * the sum being 0 mod 3, so 3^6 = 729 values cover every reachable state.
 */
static uint16_t rank_orient(const state_t *state)
{
    uint32_t rank = 0;
    for (uint8_t i = 0; i < CUBIES - 1; ++i)
        rank = (rank << 1) + rank + state->o[i]; /* rank * 3 + o[i] */
    return (uint16_t) rank;
}

/* Lehmer code of the permutation: 7! = 5040 values.
 *
 *     rank = ((((c0 * 6 + c1) * 5 + c2) * 4 + c3) * 3 + c4) * 2 + c5
 *
 * ci counts the cubies after position i with a smaller id. The radix shrinks
 * at every digit, so a loop would multiply by a variable; written out, each
 * radix is a constant and the multiply becomes shifts and adds.
 */
static uint16_t rank_perm(const state_t *state)
{
    uint8_t c[CUBIES - 1];
    for (uint8_t i = 0; i < CUBIES - 1; ++i) {
        uint8_t smaller = 0;
        for (uint8_t j = (uint8_t) (i + 1); j < CUBIES; ++j)
            smaller = (uint8_t) (smaller + (state->p[j] < state->p[i]));
        c[i] = smaller;
    }
    uint32_t rank = c[0];
    rank = (rank << 2) + (rank << 1) + c[1]; /* * 6 */
    rank = (rank << 2) + rank + c[2];        /* * 5 */
    rank = (rank << 2) + c[3];               /* * 4 */
    rank = (rank << 1) + rank + c[4];        /* * 3 */
    rank = (rank << 1) + c[5];               /* * 2 */
    return (uint16_t) rank;
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

    uint8_t d[4];
    uint32_t turned = 0;
    for (uint8_t k = 0; k < 4; ++k) {
        uint8_t pos = where[r_cubies[k]];
        /* dk = pos minus the earlier tracked cubies sitting below it, i.e.
         * the number of still-free positions below pos.
         */
        uint8_t skip = 0;
        for (uint8_t j = 0; j < k; ++j)
            skip = (uint8_t) (skip + (where[r_cubies[j]] < pos));
        d[k] = (uint8_t) (pos - skip);
        turned = (turned << 1) + turned + state->o[pos]; /* * 3 */
    }
    /* Radices 6, 5, 4 written out as constants, as in rank_perm. */
    uint32_t place = d[0];
    place = (place << 2) + (place << 1) + d[1]; /* * 6 */
    place = (place << 2) + place + d[2];        /* * 5 */
    place = (place << 2) + d[3];                /* * 4 */
    return (place << 6) + (place << 4) + place + turned; /* place * 81 */
}

#endif /* CUBE_H */
