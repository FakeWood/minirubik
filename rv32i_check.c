/* Links the search core alone, without libgcc or libc, so that any helper
 * the compiler inserts for an operation RV32I lacks (__udivsi3, __mulsi3,
 * memcpy, ...) shows up as an undefined reference.
 */
#include "search.h"

int solve(const state_t *state, uint8_t path[MAX_DEPTH])
{
    return iddfs(state, path);
}
