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

/* First move of the face each move turns, for skipping a whole face. */
static const uint8_t face_start[MOVES] = {0, 0, 0, 3, 3, 3, 6, 6, 6};

/* A move in two halves, so the search can stop after the permutation when
 * the permutation table alone already cuts the child.
 *
 * Moves are R R2 R' B B2 B' D D2 D'. Destination i takes the cubie from
 * source position s and adds a twist t to its orientation; each move is its
 * face's quarter turn composed 1, 2 or 3 times:
 *
 *     move  source         twist
 *     R     1 4 2 0 3 5 6  1 2 0 2 1 0 0
 *     R2    4 3 2 1 0 5 6  0 0 0 0 0 0 0
 *     R'    3 0 2 4 1 5 6  1 2 0 2 1 0 0
 *     B     0 1 2 4 5 6 3  0 0 0 1 2 1 2
 *     B2    0 1 2 5 6 3 4  0 0 0 0 0 0 0
 *     B'    0 1 2 6 3 4 5  0 0 0 1 2 1 2
 *     D     0 2 5 3 1 4 6  0 0 0 0 0 0 0
 *     D2    0 5 4 3 2 1 6  0 0 0 0 0 0 0
 *     D'    0 4 1 3 5 2 6  0 0 0 0 0 0 0
 *
 * A loop over these tables pays a counter, a branch, a table load and an
 * address add per cubie. Instead each move is written out with its sources
 * and twists as constants: copying a cubie is one lbu and one sb at fixed
 * offsets, and only the cubies with a non-zero twist do more.
 */
#define PERM(a, b, c, d, e, f, g)                                              \
    (q[0] = p[a], q[1] = p[b], q[2] = p[c], q[3] = p[d], q[4] = p[e],          \
     q[5] = p[f], q[6] = p[g])

static void move_perm(state_t *out, const state_t *in, uint8_t move)
{
    const uint8_t *p = in->p;
    uint8_t *q = out->p;
    switch (move) {
    case 0: PERM(1, 4, 2, 0, 3, 5, 6); break; /* R  */
    case 1: PERM(4, 3, 2, 1, 0, 5, 6); break; /* R2 */
    case 2: PERM(3, 0, 2, 4, 1, 5, 6); break; /* R' */
    case 3: PERM(0, 1, 2, 4, 5, 6, 3); break; /* B  */
    case 4: PERM(0, 1, 2, 5, 6, 3, 4); break; /* B2 */
    case 5: PERM(0, 1, 2, 6, 3, 4, 5); break; /* B' */
    case 6: PERM(0, 2, 5, 3, 1, 4, 6); break; /* D  */
    case 7: PERM(0, 5, 4, 3, 2, 1, 6); break; /* D2 */
    default: PERM(0, 4, 1, 3, 5, 2, 6); break; /* D' */
    }
}

/* plus[t][o] = (o + t) mod 3. With t a constant, one add for the address
 * and one lbu replace the sltiu, neg, andi, sub of a conditional subtract.
 */
static const uint8_t plus[3][3] = {{0, 1, 2}, {1, 2, 0}, {2, 0, 1}};

/* T0 copies an orientation; T1 and T2 add a twist of 1 or 2. */
#define T0(i, s) (q[i] = o[s])
#define T1(i, s) (q[i] = plus[1][o[s]])
#define T2(i, s) (q[i] = plus[2][o[s]])

static void move_orient(state_t *out, const state_t *in, uint8_t move)
{
    const uint8_t *o = in->o;
    uint8_t *q = out->o;
    switch (move) {
    case 0: /* R */
        T1(0, 1), T2(1, 4), T0(2, 2), T2(3, 0), T1(4, 3), T0(5, 5), T0(6, 6);
        break;
    case 1: /* R2 */
        T0(0, 4), T0(1, 3), T0(2, 2), T0(3, 1), T0(4, 0), T0(5, 5), T0(6, 6);
        break;
    case 2: /* R' */
        T1(0, 3), T2(1, 0), T0(2, 2), T2(3, 4), T1(4, 1), T0(5, 5), T0(6, 6);
        break;
    case 3: /* B */
        T0(0, 0), T0(1, 1), T0(2, 2), T1(3, 4), T2(4, 5), T1(5, 6), T2(6, 3);
        break;
    case 4: /* B2 */
        T0(0, 0), T0(1, 1), T0(2, 2), T0(3, 5), T0(4, 6), T0(5, 3), T0(6, 4);
        break;
    case 5: /* B' */
        T0(0, 0), T0(1, 1), T0(2, 2), T1(3, 6), T2(4, 3), T1(5, 4), T2(6, 5);
        break;
    case 6: /* D */
        T0(0, 0), T0(1, 2), T0(2, 5), T0(3, 3), T0(4, 1), T0(5, 4), T0(6, 6);
        break;
    case 7: /* D2 */
        T0(0, 0), T0(1, 5), T0(2, 4), T0(3, 3), T0(4, 2), T0(5, 1), T0(6, 6);
        break;
    default: /* D' */
        T0(0, 0), T0(1, 4), T0(2, 1), T0(3, 3), T0(4, 5), T0(5, 2), T0(6, 6);
        break;
    }
}

#undef PERM
#undef T0
#undef T1
#undef T2

/* Both halves, for the host tools that need whole moves. inline, so files
 * that only use the halves do not warn that it is unused.
 */
static inline void apply_move(state_t *out, const state_t *in, uint8_t move)
{
    move_perm(out, in, move);
    move_orient(out, in, move);
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
 *
 * Both loops have fixed trip counts, so they are unrolled too: the 7 ids are
 * loaded once into registers, and the 21 comparisons are one sltu and one add
 * each, with no loop counter, no branch and no address arithmetic. Locals are
 * 32-bit because RV32I has no 8-bit ALU: a uint8_t would cost an andi after
 * every add.
 */
static uint16_t rank_perm(const state_t *state)
{
    const uint8_t *p = state->p;
    uint32_t p0 = p[0], p1 = p[1], p2 = p[2], p3 = p[3], p4 = p[4],
             p5 = p[5], p6 = p[6];
    uint32_t c0 = (p1 < p0) + (p2 < p0) + (p3 < p0) + (p4 < p0) + (p5 < p0) +
                  (p6 < p0);
    uint32_t c1 = (p2 < p1) + (p3 < p1) + (p4 < p1) + (p5 < p1) + (p6 < p1);
    uint32_t c2 = (p3 < p2) + (p4 < p2) + (p5 < p2) + (p6 < p2);
    uint32_t c3 = (p4 < p3) + (p5 < p3) + (p6 < p3);
    uint32_t c4 = (p5 < p4) + (p6 < p4);
    uint32_t c5 = (p6 < p5);

    uint32_t rank = c0;
    rank = (rank << 2) + (rank << 1) + c1; /* * 6 */
    rank = (rank << 2) + rank + c2;        /* * 5 */
    rank = (rank << 2) + c3;               /* * 4 */
    rank = (rank << 1) + rank + c4;        /* * 3 */
    rank = (rank << 1) + c5;               /* * 2 */
    return (uint16_t) rank;
}

/* The cubies that sit on the R face when solved; R cycles exactly these.
 * rank_r_face is unrolled over them, so it names 0, 1, 3, 4 directly.
 */
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
    const uint8_t *p = state->p, *o = state->o;

    /* where[cubie] = position, the inverse of p[position] = cubie. Unrolled,
     * each store is lbu, add, sb with the position as a constant.
     */
    uint8_t where[CUBIES];
    where[p[0]] = 0;
    where[p[1]] = 1;
    where[p[2]] = 2;
    where[p[3]] = 3;
    where[p[4]] = 4;
    where[p[5]] = 5;
    where[p[6]] = 6;

    /* Positions of r_cubies {0, 1, 3, 4}, read at constant offsets. */
    uint32_t w0 = where[0], w1 = where[1], w3 = where[3], w4 = where[4];

    /* dk = pos minus the earlier tracked cubies sitting below it, i.e. the
     * number of still-free positions below pos: 6 sltu and 6 sub in all.
     */
    uint32_t d1 = w1 - (w0 < w1);
    uint32_t d2 = w3 - (w0 < w3) - (w1 < w3);
    uint32_t d3 = w4 - (w0 < w4) - (w1 < w4) - (w3 < w4);

    /* Radices 6, 5, 4 written out as constants, as in rank_perm. */
    uint32_t place = w0;
    place = (place << 2) + (place << 1) + d1; /* * 6 */
    place = (place << 2) + place + d2;        /* * 5 */
    place = (place << 2) + d3;                /* * 4 */

    uint32_t turned = o[w0];
    turned = (turned << 1) + turned + o[w1]; /* * 3 */
    turned = (turned << 1) + turned + o[w3];
    turned = (turned << 1) + turned + o[w4];
    return (place << 6) + (place << 4) + place + turned; /* place * 81 */
}

#endif /* CUBE_H */
