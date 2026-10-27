#ifndef OP_H
#define OP_H
#define K_S 3

static unsigned char kop(unsigned char w[3][3]) {
#pragma HLS INLINE
    const int mask[3][3] = {{1, 2, 1}, {2, 4, 2}, {1, 2, 1}};
    int acc = 0;
    for (int j = 0; j < 3; j++) {
#pragma HLS UNROLL
        for (int i = 0; i < 3; i++) {
#pragma HLS UNROLL
            acc += w[j][i] * mask[j][i];
        }
    }
    return (unsigned char)(acc >> 4);
}
#endif
