#ifndef OP_H
#define OP_H
#define K_S 3

static unsigned char kop(unsigned char w[3][3]) {
#pragma HLS INLINE
    unsigned char v[9];
#pragma HLS ARRAY_PARTITION variable=v complete
    for (int j = 0; j < 3; j++) {
#pragma HLS UNROLL
        for (int i = 0; i < 3; i++) {
#pragma HLS UNROLL
            v[j * 3 + i] = w[j][i];
        }
    }
    for (int a = 0; a < 9; a++) {
#pragma HLS UNROLL
        for (int b = 0; b < 8 - a; b++) {
#pragma HLS UNROLL
            if (v[b] > v[b + 1]) {
                unsigned char t = v[b];
                v[b] = v[b + 1];
                v[b + 1] = t;
            }
        }
    }
    return v[4];
}
#endif
