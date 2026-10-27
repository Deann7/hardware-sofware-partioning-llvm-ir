// 3x3 median filter (bubble sort over the 9-pixel window, data-dependent swaps).
void median_filter(unsigned char input[64][64], unsigned char output[64][64]) {
    Y_LOOP:
    for (int y = 0; y < 64; y++) {
        X_LOOP:
        for (int x = 0; x < 64; x++) {
            if (y == 0 || y == 63 || x == 0 || x == 63) {
                output[y][x] = 0;
            } else {
                unsigned char v[9];
                int k = 0;
                for (int j = -1; j <= 1; j++) {
                    for (int i = -1; i <= 1; i++) {
                        v[k++] = input[y + j][x + i];
                    }
                }
                for (int a = 0; a < 9; a++) {
                    for (int b = 0; b < 8 - a; b++) {
                        if (v[b] > v[b + 1]) {
                            unsigned char t = v[b];
                            v[b] = v[b + 1];
                            v[b + 1] = t;
                        }
                    }
                }
                output[y][x] = v[4];
            }
        }
    }
}
