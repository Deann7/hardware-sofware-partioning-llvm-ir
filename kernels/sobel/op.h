#ifndef OP_H
#define OP_H
#define K_S 3

static unsigned char kop(unsigned char w[3][3]) {
#pragma HLS INLINE
    const int gx_mask[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    const int gy_mask[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
    int gx = 0, gy = 0;
    for (int j = 0; j < 3; j++) {
#pragma HLS UNROLL
        for (int i = 0; i < 3; i++) {
#pragma HLS UNROLL
            gx += w[j][i] * gx_mask[j][i];
            gy += w[j][i] * gy_mask[j][i];
        }
    }
    int abs_gx = (gx < 0) ? -gx : gx;
    int abs_gy = (gy < 0) ? -gy : gy;
    int magnitude = abs_gx + abs_gy;
    return (magnitude > 255) ? (unsigned char)255 : (unsigned char)magnitude;
}
#endif
