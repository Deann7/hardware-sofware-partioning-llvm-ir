// Software reference (identical to Percobaan1/sobel.cpp, loop labels added).
// Input to the LLVM partitioning pass and top function of the monolithic HLS baseline.
void sobel_codesign_filter(unsigned char input[64][64], unsigned char output[64][64]) {
    int gx_mask[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int gy_mask[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};

    Y_LOOP:
    for (int y = 0; y < 64; y++) {
        X_LOOP:
        for (int x = 0; x < 64; x++) {
            if (y == 0 || y == 63 || x == 0 || x == 63) {
                output[y][x] = 0;
            } else {
                int gx = 0;
                int gy = 0;

                for (int j = -1; j <= 1; j++) {
                    for (int i = -1; i <= 1; i++) {
                        int py = y + j;
                        int px = x + i;
                        unsigned char pixel = input[py][px];

                        int wx = gx_mask[j + 1][i + 1];
                        int wy = gy_mask[j + 1][i + 1];

                        gx += pixel * wx;
                        gy += pixel * wy;
                    }
                }

                int abs_gx = (gx < 0) ? -gx : gx;
                int abs_gy = (gy < 0) ? -gy : gy;
                int magnitude = abs_gx + abs_gy;

                if (magnitude > 255) {
                    output[y][x] = 255;
                } else {
                    output[y][x] = (unsigned char)magnitude;
                }
            }
        }
    }
}
