// Manually partitioned window kernel: the designer moves the image loops to software
// and packs the K_S x K_S window into one wide AXI4-Lite argument.
#include "ap_int.h"
#include "op.h"

void sobel_win(ap_uint<8 * K_S * K_S> win, unsigned char *result) {
#pragma HLS INTERFACE s_axilite port=return bundle=control
#pragma HLS INTERFACE s_axilite port=win bundle=control
#pragma HLS INTERFACE s_axilite port=result bundle=control
#pragma HLS PIPELINE II=1
    unsigned char w[K_S][K_S];
#pragma HLS ARRAY_PARTITION variable=w complete dim=0
    for (int j = 0; j < K_S; j++) {
#pragma HLS UNROLL
        for (int i = 0; i < K_S; i++) {
#pragma HLS UNROLL
            w[j][i] = win.range(8 * (j * K_S + i) + 7, 8 * (j * K_S + i));
        }
    }
    *result = kop(w);
}
