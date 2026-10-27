// 5x5 Gaussian convolution with non-power-of-two coefficients (sum = 273).
void conv5_filter(unsigned char input[64][64], unsigned char output[64][64]) {
    int mask[5][5] = {{1, 4, 7, 4, 1},
                      {4, 16, 26, 16, 4},
                      {7, 26, 41, 26, 7},
                      {4, 16, 26, 16, 4},
                      {1, 4, 7, 4, 1}};

    Y_LOOP:
    for (int y = 0; y < 64; y++) {
        X_LOOP:
        for (int x = 0; x < 64; x++) {
            if (y < 2 || y > 61 || x < 2 || x > 61) {
                output[y][x] = 0;
            } else {
                int acc = 0;
                for (int j = -2; j <= 2; j++) {
                    for (int i = -2; i <= 2; i++) {
                        acc += input[y + j][x + i] * mask[j + 2][i + 2];
                    }
                }
                output[y][x] = (unsigned char)(acc / 273);
            }
        }
    }
}
