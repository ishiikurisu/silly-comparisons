#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define ITER_LIMIT 1000
#define REPS 100

float pythagoras(float a, float b) {
    return sqrt(a*a + b*b);
}

int mandelbrot(float x, float y) {
    int i = 0;
    float zx = 0.0;
    float zy = 0.0;
    float temp;
    
    for (i = 0; i < ITER_LIMIT && pythagoras(zx, zy) < 2.0; ++i) {
        temp = zx*zx - zy*zy + x;
        zy = 2*zx*zy + y;
        zx = temp;
    }

    return i;
}

void mandelbrot_fractal(int* f, int w, int h, float x0, float y0, float x1, float y1) {
    int i, j;
    float pd = fabsf(h / (y1 - y0));
    float x, y;
    for (j = 0; j < h; ++j) {
        for (i = 0; i < w; ++i) {
            x = i / pd + x0;
            y = -j / pd + y0;
            f[i + w * j] = mandelbrot(x, y);
        }
    }
}

void setup() {
    int width = 1600;
    int height = 900;
    float x0 = -width * 2.0 / height;
    float y0 = 2.0;
    float x1 = 2.0 * width / height;
    float y1 = -2.0;
    int i;

    /* test run */
    int* fractal = (int*) malloc(sizeof(int) * width * height);
    mandelbrot_fractal(fractal, width, height, x0, y0, x1, y1);

    FILE* fp = fopen("mandelbrot.c.ppm", "w");
    fprintf(fp, "P1 %d %d", width, height);
    for (i = 0; i < width * height; i++) {
        fprintf(fp, " %d", (fractal[i] == ITER_LIMIT)? 1 : 0);
    }
    fclose(fp);
    free(fractal);

    /* TODO run remaining tests */
    double average = 0.0;
    double duration;
    clock_t start_time, end_time;
    for (i = 1; i <= REPS; ++i) {
        start_time = clock();
        int* fractal = (int*) malloc(sizeof(int) * width * height);
        mandelbrot_fractal(fractal, width, height, x0, y0, x1, y1);
        free(fractal);
        end_time = clock();
        duration = (double) end_time - start_time;
        average = average + (duration - average)/i;
    }
    printf("---\n");
    printf("language: c\n");
    printf("average duration: %.5fs\n", average);
}

int main() {
    setup();
    return 0;
}

