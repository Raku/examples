#include <assert.h>

// big enough for N = 4
#define CACHE_SIZE (1 << 18)

static int cache[CACHE_SIZE];

int factors(int n) {
    if(n < 2)
        return 0;

    assert(n < CACHE_SIZE);

    if(cache[n])
        return cache[n];

    for(int p = 2; p * p <= n; ++p) {
        if(n % p == 0) {
            int r = n / p;
            while(r % p == 0)
                r /= p;

            return (cache[n] = 1 + factors(r));
        }
    }

    return (cache[n] = 1);
}

// vim: expandtab shiftwidth=4
