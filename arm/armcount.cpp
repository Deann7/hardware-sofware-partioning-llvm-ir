// CPU-only reference timing on ARMv7 (Cortex-A9 class): runs the software reference
// filter `reps` times on a fixed 64x64 image. Dynamic instruction count per image is
// obtained under qemu-arm as count(reps=1) - count(reps=0) (see scripts/arm_count.sh).
#include <cstdio>
#include <cstdlib>
#include "ref.cpp"

static unsigned char in[64][64], out[64][64];

int main(int argc, char **argv) {
    int reps = argc > 1 ? atoi(argv[1]) : 1;
    unsigned int s = 12345u;
    for (int y = 0; y < 64; y++)
        for (int x = 0; x < 64; x++) { s = s * 1103515245u + 12345u; in[y][x] = (s >> 16) & 0xff; }
    for (int r = 0; r < reps; r++) KREF(in, out);
    unsigned int sum = 0;
    for (int y = 0; y < 64; y++)
        for (int x = 0; x < 64; x++) sum = sum * 31u + out[y][x];
    printf("checksum %08x\n", sum);
    return 0;
}
