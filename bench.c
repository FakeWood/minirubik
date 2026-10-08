#include "search.h"
#define N 1024
/* 16 scrambled states so data-dependent paths are exercised. */
static state_t st[16];
static volatile uint32_t sink;
int main(void)
{
    state_t s = {{0,1,2,3,4,5,6},{0}}, t;
    static const uint8_t scramble[32] = {1,3,6,4,2,8,0,5,7,3,1,6,5,0,8,4,2,7,3,0,6,1,4,8,5,2,7,0,3,6,1,5};
    for (int i = 0; i < 16; ++i) { apply_move(&t, &s, scramble[2 * i]); apply_move(&s, &t, scramble[2 * i + 1]); st[i] = s; }
    uint32_t acc = 0;
    for (int i = 0; i < N; ++i) {
        state_t *x = &st[i & 15];
#if BENCH == 1
        apply_move(&t, x, (uint8_t)(i & 7)); acc += t.p[0];
#elif BENCH == 2
        acc += rank_orient(x);
#elif BENCH == 3
        acc += rank_perm(x);
#elif BENCH == 4
        acc += rank_r_face(x);
#elif BENCH == 5
        acc += heuristic(x);
#else
        acc += x->p[0];
#endif
        __asm__ volatile("" ::: "memory");
    }
    sink = acc;
    return 0;
}
