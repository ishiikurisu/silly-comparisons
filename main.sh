#!/bin/sh

set -e

# C
gcc main.c -lm -Wall -O2 -o main
./main
rm main
convert mandelbrot.c.ppm mandelbrot.c.png

# GO
go build main.go
./main
rm main
convert mandelbrot.go.ppm mandelbrot.go.png

# CLOJURE
cd clj
lein uberjar
mv target/uberjar/mandelbrot-0.1.0-SNAPSHOT.jar ../mandelbrot.jar
cd ..
java -jar mandelbrot.jar
convert mandelbrot.clj.ppm mandelbrot.clj.png
rm temp.end
rm mandelbrot.jar

# PYTHON
python3 main.py
convert mandelbrot.py.ppm mandelbrot.py.png

# RUBY
ruby main.rb
convert mandelbrot.rb.ppm mandelbrot.rb.png

# LUA
lua main.lua
convert mandelbrot.lua.ppm mandelbrot.lua.png

# cleanup
rm *.ppm

