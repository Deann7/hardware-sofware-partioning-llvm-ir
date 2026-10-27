// Generic K_S x K_S stencil over a 64x64 image using line buffers.
// Requires op.h (K_S, kop) and STREAM_TOP to be defined by the includer.
// Output order and border handling (border pixels = 0) match the software reference.
#include "hls_stream.h"
#include "ap_axi_sdata.h"

#ifndef IMG_N
#define IMG_N 64
#endif
#define K_R (K_S / 2)
typedef ap_axiu<8, 0, 0, 0> axis8_t;

void STREAM_TOP(hls::stream<axis8_t> &in, hls::stream<axis8_t> &out) {
#pragma HLS INTERFACE axis port=in
#pragma HLS INTERFACE axis port=out
#pragma HLS INTERFACE s_axilite port=return bundle=control
    unsigned char lb[K_S - 1][IMG_N];
#pragma HLS ARRAY_PARTITION variable=lb complete dim=1
    unsigned char win[K_S][K_S];
#pragma HLS ARRAY_PARTITION variable=win complete dim=0

ROW:
    for (int r = 0; r < IMG_N + K_R; r++) {
    COL:
        for (int c = 0; c < IMG_N + K_R; c++) {
#pragma HLS PIPELINE II=1
            unsigned char colv[K_S];
#pragma HLS ARRAY_PARTITION variable=colv complete
            if (c < IMG_N) {
                unsigned char p = 0;
                if (r < IMG_N) p = in.read().data;
                for (int k = 0; k < K_S - 1; k++) colv[k] = lb[k][c];
                colv[K_S - 1] = p;
                for (int k = 0; k < K_S - 2; k++) lb[k][c] = lb[k + 1][c];
                lb[K_S - 2][c] = p;
            } else {
                for (int k = 0; k < K_S; k++) colv[k] = 0;
            }
            for (int i = 0; i < K_S; i++) {
                for (int j = 0; j < K_S - 1; j++) win[i][j] = win[i][j + 1];
                win[i][K_S - 1] = colv[i];
            }
            if (r >= K_R && c >= K_R) {
                int y = r - K_R, x = c - K_R;
                unsigned char v = 0;
                if (!(y < K_R || y >= IMG_N - K_R || x < K_R || x >= IMG_N - K_R)) v = kop(win);
                axis8_t o;
                o.data = v;
                o.keep = 1;
                o.strb = 1;
                o.last = (y == IMG_N - 1 && x == IMG_N - 1);
                out.write(o);
            }
        }
    }
}
