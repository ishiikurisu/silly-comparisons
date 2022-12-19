package main

import (
    "fmt"
    "math"
    "os"
    "time"
)

func screenToComplexPlane(i int,
                          j int,
                          w int,
                          h int,
                          x0 float64, 
                          y0 float64,
                          x1 float64,
                          y1 float64) (float64, float64) {
    pd := math.Abs(float64(h) / (y1 - y0))
    x := float64(i) / pd + x0
    y := float64(-j) / pd + y0
    return x, y
}

func pythagoras(x, y float64) float64 {
    return math.Sqrt(x*x + y*y)
}

func mandelbrot(x float64, y float64, iterLimit int) int {
    i := 0
    zx := 0.0
    zy := 0.0
    temp := 0.0

    for i < iterLimit && pythagoras(zx, zy) < 2.0 {
        temp = zx*zx - zy*zy + x
        zy = 2*zx*zy + y
        zx = temp
        i++
    }

    return i
}

func mandelbrotFractal(w int, 
                       h int,
                       x0 float64,
                       y0 float64,
                       x1 float64,
                       y1 float64,
                       iterLimit int) []int {
    fractal := make([]int, w * h)

    for j := 0; j < h; j++ {
        for i := 0; i < w; i++ {
            x, y := screenToComplexPlane(i, j, w, h, x0, y0, x1, y1)
            fractal[i + w * j] = mandelbrot(x, y, iterLimit)
        }
    }
    
    return fractal
}

func main() {
    iterLimit := 1000
    width := 1600
    height := 900
    x0 := 2.0 * float64(-width) / float64(height)
    y0 := 2.0
    x1 := 2.0 * float64(width) / float64(height)
    y1 := -2.0

    // test run
    fractal := mandelbrotFractal(width, height, x0, y0, x1, y1, iterLimit)

    fp, oops := os.Create("mandelbrot.go.ppm") 
    if oops != nil {
        panic("couldn't create file!")
    }
    defer fp.Close()

    line := fmt.Sprintf("P1 %d %d", width, height)
    fp.WriteString(line)
    for _, x := range fractal {
        line = " 0"
        if x == iterLimit {
            line = " 1"
        }
        fp.WriteString(line)
    }

    reps := 100
    average := 0.0
    for i := 1; i <= reps; i++ {
        startTime := time.Now()    
        mandelbrotFractal(width, height, x0, y0, x1, y1, iterLimit)
        duration := time.Since(startTime)
        average = average + (duration.Seconds() - average)/float64(i)
    }
    fmt.Printf("---\n")
    fmt.Printf("language: go\n")
    fmt.Printf("average duration: %.5fs\n", average)
}

