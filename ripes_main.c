/* Entry point for running the compiled search core on Ripes. Ripes has no
 * argv, so the state to solve is fixed here, and the result is printed with
 * Ripes' environment calls instead of printf.
 */
#include "search.h"

/* 54721631111111, the distance-11 state that expands the most nodes. */
static const state_t start = {
    {4, 3, 6, 1, 0, 5, 2},
    {0, 0, 0, 0, 0, 0, 0},
};

/* Ripes ecall: a7 selects the service, a0 is its argument. */
static void ecall(int service, int arg)
{
    register int a0 __asm__("a0") = arg;
    register int a7 __asm__("a7") = service;
    __asm__ volatile("ecall" : : "r"(a0), "r"(a7) : "memory");
}

enum { PRINT_INT = 1, PRINT_CHAR = 11 };

int main(void)
{
    uint8_t path[MAX_DEPTH];
    int length = iddfs(&start, path);

    /* Length, then the move indices (0..8 = R R2 R' B B2 B' D D2 D'), then
     * the node count, so the run can be checked against the host.
     */
    ecall(PRINT_INT, length);
    ecall(PRINT_CHAR, ':');
    for (int i = 0; i < length; ++i) {
        ecall(PRINT_CHAR, ' ');
        ecall(PRINT_INT, path[i]);
    }
    ecall(PRINT_CHAR, '\n');
    ecall(PRINT_INT, (int) nodes);
    ecall(PRINT_CHAR, '\n');
    return 0;
}
