#include <stdint.h>
#include <stdio.h>
#include <string.h>

enum {
    CUBIES = 7,
    MOVES = 9,
    MAX_DEPTH = 11, /* HTM diameter: no state needs more moves */
};

typedef struct {
    uint8_t p[CUBIES], o[CUBIES];
} state_t;

static const char *const move_names[MOVES] = {"R",  "R2", "R'", "B", "B2",
                                              "B'", "D",  "D2", "D'"};
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

static int is_solved(const state_t *state)
{
    for (uint8_t i = 0; i < CUBIES; ++i)
        if (state->p[i] != i || state->o[i] != 0)
            return 0;
    return 1;
}

static int valid(const state_t *state)
{
    uint8_t sum = 0;
    for (uint8_t i = 0; i < CUBIES; ++i) {
        if (state->p[i] >= CUBIES || state->o[i] >= 3)
            return 0;
        for (uint8_t j = 0; j < i; ++j)
            if (state->p[j] == state->p[i])
                return 0;
        sum = (uint8_t) (sum + state->o[i]);
    }
    return sum % 3U == 0;
}

static int parse_state(const char *input, state_t *state)
{
    for (int i = 0; i < 14; ++i) {
        int limit = i < 7 ? 7 : 3;
        if (input[i] < '1' || input[i] > '0' + limit)
            return 0;
        (i < 7 ? state->p : state->o)[i % 7] = (uint8_t) (input[i] - '1');
    }
    return input[14] == '\0' && valid(state);
}

/* Naive depth-first search without recursion: an explicit stack of states and
 * the next move to try at each depth. A branch is cut only when it would grow
 * past MAX_DEPTH moves. Returns the length of the first solution found (not
 * necessarily the shortest), or -1 if none exists within MAX_DEPTH.
 */
static int dfs(state_t start, uint8_t path[MAX_DEPTH])
{
    state_t stack[MAX_DEPTH + 1];  // [0, 11]
    uint8_t next[MAX_DEPTH + 1];   // [0, 9]
    int depth = 0;

    if (is_solved(&start))
        return 0;
    stack[0] = start;
    next[0] = 0;
    while (depth >= 0) {
        if (depth == MAX_DEPTH || next[depth] == MOVES) {
            --depth;
            continue;
        }
        uint8_t move = next[depth]++;
        path[depth] = move;
        stack[depth + 1] = apply_move(stack[depth], move);
        if (is_solved(&stack[depth + 1]))
            return depth + 1;
        next[++depth] = 0;
    }
    return -1;
}

int main(int argc, char **argv)
{
    state_t state;
    uint8_t path[MAX_DEPTH];

    if (argc != 2 || !parse_state(argv[1], &state)) {
        fprintf(stderr, "usage: %s PPPPPPPOOOOOOO\n",
                argc > 0 && argv[0] ? argv[0] : "my_solver");
        return 2;
    }
    int length = dfs(state, path);
    if (length < 0) {
        fputs("no solution within 11 moves\n", stderr);
        return 1;
    }
    for (int i = 0; i < length; ++i)
        printf("%s%s", i ? " " : "", move_names[path[i]]);
    putchar('\n');
    return 0;
}
