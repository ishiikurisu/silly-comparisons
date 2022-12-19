def screen_to_complex_plane i, j, w, h, x0, y0, x1, y1
  pd = (h / (y1 - y0)).abs
  return i / pd + x0, -j / pd + y0
end

def pythagoras(x, y)
  Math.sqrt(x*x + y*y)
end

def mandelbrot(x, y, iter_limit)
  i = 0
  zx = 0.0
  zy = 0.0
  while i < iter_limit && pythagoras(zx, zy) <= 2.0
    zx, zy = zx*zx - zy*zy + x, 2*zx*zy + y
    i += 1
  end
  return i
end

def mandelbrot_fractal w, h, x0, y0, x1, y1, iter_limit
  fractal = []
  h.times do |j|
    w.times do |i|
      x, y = screen_to_complex_plane i, j, w, h, x0, y0, x1, y1
      fractal << mandelbrot(x, y, iter_limit)
    end
  end
  return fractal
end

def main
  iter_limit = 1000
  width = 1600
  height = 900
  x0 = - width * 2.0 / height
  y0 = 2.0
  x1 = width * 2.0 / height
  y1 = -2.0

  # test run
  fractal = mandelbrot_fractal width, height, x0, y0, x1, y1, iter_limit
  File.open("mandelbrot.rb.ppm", "w") do |fp|
    fp.write "P1 #{width} #{height} "
    fractal.each do |i|
      fp.write "#{(i == iter_limit)? 1 : 0}"
    end
  end

  # calculations
  reps = 100
  average = 0.0
  reps.times do |i|
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    mandelbrot_fractal width, height, x0, y0, x1, y1, iter_limit
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    duration = end_time - start_time
    average = average + (duration - average)/(i + 1)
  end
  puts "---"
  puts "language: ruby"
  puts "average duration: #{average}s"
end

main
