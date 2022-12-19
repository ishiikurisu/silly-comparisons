from time import process_time


def screen_to_complex_plane(i, j, w, h, x0, y0, x1, y1):
    pd = abs(h / (y1 - y0))
    x = i / pd + x0
    y = -j / pd + y0
    return x, y


def pythagoras(x, y):
    return (x*x + y*y) ** 0.5


def mandelbrot(x, y, iter_limit):
    i = 0
    zx = 0.0
    zy = 0.0
    
    while i < iter_limit and pythagoras(zx, zy) <= 2.0:
        zx, zy = zx*zx - zy*zy + x, 2*zx*zy + y
        i += 1

    return i


def mandelbrot_fractal(w, h, x0, y0, x1, y1, iter_limit):
    fractal = [0] * (w * h)
    for j in range(0, h):
        for i in range(0, w):
            x, y = screen_to_complex_plane(i, j, w, h, x0, y0, x1, y1)
            fractal[i + w * j] = mandelbrot(x, y, iter_limit)
    return fractal


def main():
    iter_limit = 1000
    width = 1600
    height = 900
    x0 = -width * 2 / height
    x1 = width * 2 / height
    y0 = 2.0
    y1 = -2.0
    fractal = mandelbrot_fractal(1600, 900, x0, y0, x1, y1, iter_limit)

    # test run
    with open("mandelbrot.py.ppm", "w") as fp:
        fp.write(f"P1 {width} {height} ")
        for x in fractal:
            fp.write(f"{1 if x == iter_limit else 0} ")

    # execution time
    reps = 100
    average = 0.0
    for i in range(reps):
        start_time = process_time()
        mandelbrot_fractal(width, height, x0, y0, x1, y1, iter_limit)
        duration = process_time() - start_time
        average = average + (duration - average)/(i + 1)
    print("---")
    print("language: python")
    print(f"average duration: {average}s")

if __name__ == "__main__":
    main()

