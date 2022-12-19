function screen_to_complex_plane(i, j, w, h, x0, y0, x1, y1)
 local pd = math.abs(h / (y1 - y0))
 local x = i / pd + x0
 local y = -j / pd + y0
 return x, y
end

function pythagoras(x, y)
  return (x*x + y*y)^0.5
end

function mandelbrot(x, y, iter_limit)
 local i = 0
 local zx = 0.0
 local zy = 0.0
 local temp = 0.0

 while i < iter_limit and pythagoras(zx, zy) < 2.0 do
   temp = zx*zx - zy*zy + x
   zy = 2*zx*zy + y
   zx = temp
   i = i + 1
 end

 return i
end

function mandelbrot_fractal(w, h, x0, y0, x1, y1, iter_limit)
 local fractal = { }
 for j = 1, h do for i = 1, w do
  x, y = screen_to_complex_plane(i, j, w, h, x0, y0, x1, y1)
  table.insert(fractal, mandelbrot(x, y, iter_limit))
 end end
 return fractal
end

function main()
 local iter_limit = 1000
 local w = 1600
 local h = 900
 local x0 = -w * 2 / h
 local y0 = 2
 local x1 = w * 2 / h
 local y1 = -2
 
 -- test run
 local fractal = mandelbrot_fractal(w, h, x0, y0, x1, y1, iter_limit)
 local fp = io.open("mandelbrot.lua.ppm", "w")
 fp:write("P1 " .. w .. " " .. h)
 for i, x in pairs(fractal) do
  local v = "0"
  if x == iter_limit then
   v = "1"
  end
  fp:write(" " .. v)
 end
 fp:close()

 -- execute tests
 local reps = 100
 local average = 0
 for i = 1, reps do
  start_time = os.clock()
  mandelbrot_fractal(w, h, x0, y0, x1, y1, iter_limit)
  end_time = os.clock()
  duration = end_time - start_time
  average = average + (duration - average)/i
 end
 print("---")
 print("language: lua")
 print("average duration: " .. average .. "s")
end

main()
