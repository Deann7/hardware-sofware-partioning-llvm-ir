// Hardware-isolated datapath extracted by the LLVM partitioning pass.
// Intended for AMD/Xilinx Vivado HLS / Vitis HLS.

void sobel_hw_datapath(unsigned char window[3][3], unsigned char *result) {
    // SEMUA PRAGMA INTERFACE WAJIB DI DALAM SINI!
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS INTERFACE s_axilite port=window bundle=control
    #pragma HLS INTERFACE s_axilite port=result bundle=control

    const int gx_mask[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    const int gy_mask[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};

    int gx = 0;
    int gy = 0;

    #pragma HLS PIPELINE II=1
    ROW_LOOP:
    for (int j = 0; j < 3; j++) {
        #pragma HLS UNROLL
        COL_LOOP:
        for (int i = 0; i < 3; i++) {
            #pragma HLS UNROLL
            unsigned char pixel = window[j][i];

            int wx = gx_mask[j][i];
            int wy = gy_mask[j][i];

            gx += pixel * wx;
            gy += pixel * wy;
        }
    }

    int abs_gx = (gx < 0) ? -gx : gx;
    int abs_gy = (gy < 0) ? -gy : gy;
    int magnitude = abs_gx + abs_gy;

    *result = (magnitude > 255) ? (unsigned char)255 : (unsigned char)magnitude;
}