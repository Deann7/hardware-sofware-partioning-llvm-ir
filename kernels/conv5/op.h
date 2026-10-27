#ifndef OP_H
#define OP_H
#define K_S 5

static unsigned char kop(unsigned char w[5][5]) {
#pragma HLS INLINE
    const int mask[5][5] = {{1, 4, 7, 4, 1},
                            {4, 16, 26, 16, 4},
                            {7, 26, 41, 26, 7},
                            {4, 16, 26, 16, 4},
                            {1, 4, 7, 4, 1}};
    int acc = 0;
    for (int j = 0; j < 5; j++) {
#pragma HLS UNROLL
        for (int i = 0; i < 5; i++) {
#pragma HLS UNROLL
            acc += w[j][i] * mask[j][i];
        }
    }
    return (unsigned char)(acc / 273);
}
#endif
