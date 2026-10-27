// 3x3 Gaussian blur (binomial 1-2-1 mask, divide by 16).
void gauss_filter(unsigned char input[64][64], unsigned char output[64][64]) {
    int mask[3][3] = {{1, 2, 1}, {2, 4, 2}, {1, 2, 1}};

    Y_LOOP:
    for (int y = 0; y < 64; y++) {
        X_LOOP:
        for (int x = 0; x < 64; x++) {
            if (y == 0 || y == 63 || x == 0 || x == 63) {
                output[y][x] = 0;
            } else {
                int acc = 0;
                for (int j = -1; j <= 1; j++) {
                    for (int i = -1; i <= 1; i++) {
                        acc += input[y + j][x + i] * mask[j + 1][i + 1];
                    }
                }
                output[y][x] = (unsigned char)(acc >> 4);
            }
        }
    }
}
