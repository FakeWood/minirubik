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

int main(int argc, char **argv)
{
    state_t state;
    uint8_t path[MAX_DEPTH];

    if (argc != 2 || !parse_state(argv[1], &state)) {
        fprintf(stderr, "usage: %s PPPPPPPOOOOOOO\n",
                argc > 0 && argv[0] ? argv[0] : "my_solver");
        return 2;
    }
    int length = iddfs(state, path);
    fprintf(stderr, "nodes: %lu\n", nodes);
    if (length < 0) {
        fputs("no solution within 11 moves\n", stderr);
        return 1;
    }
    for (int i = 0; i < length; ++i)
        printf("%s%s", i ? " " : "", move_names[path[i]]);
    putchar('\n');
    return 0;
}
