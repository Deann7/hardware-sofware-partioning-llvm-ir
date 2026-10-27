// Full-image check of the partitioned program: the rewritten software IR (sw.ll),
// which calls the pass-generated hardware kernel (hw.cpp), against the original source.
#include <cstdio>
#include "kcfg.h"

namespace golden {
#include "ref.cpp"
}
void K_REF(unsigned char input[64][64], unsigned char output[64][64]); // from sw.ll

int main() {
    static unsigned char in[64][64], ref[64][64], dut[64][64];
    int errors = 0;
    for (int id = 0; id < 8; id++) {
        unsigned int s = 777u + 104729u * id;
        for (int y = 0; y < 64; y++)
            for (int x = 0; x < 64; x++) {
                s = s * 1103515245u + 12345u;
                in[y][x] = (id & 1) ? (unsigned char)((s >> 16) & 0xff)
                                    : (unsigned char)(((x * (id + 1)) ^ (y * 3)) & 0xff);
            }
        golden::K_REF(in, ref);
        K_REF(in, dut);
        for (int y = 0; y < 64; y++)
            for (int x = 0; x < 64; x++) errors += ref[y][x] != dut[y][x];
    }
    printf("%s: %d mismatches over 8 images\n", errors ? "FAIL" : "PASS", errors);
    return errors != 0;
}
