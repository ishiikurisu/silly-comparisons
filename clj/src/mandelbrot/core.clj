(ns mandelbrot.core
  (:gen-class))

(def iter-limit 1000)

(defn- pythagoras [x y]
  (Math/sqrt (+ (* x x) (* y y))))

(defn- mandelbrot [x y]
  (loop [i 0
         zx 0
         zy 0]
    (if (and (< i iter-limit)
             (< (pythagoras zx zy) 2))
      (recur (inc i) 
             (+ x (* zx zx) (- (* zy zy)))
             (+ y (* 2 zx zy)))
      i)))

(defn mandelbrot-fractal [w h x0 y0 x1 y1]
  (let [pd (abs (/ h (- y1 y0)))]
    (for [x (->> w
                 range
                 (map #(+ x0 (/ % pd))))
          y (->> h
                 range
                 (map #(+ y0 (/ (- %) pd))))]
      (mandelbrot x y))))

(defn -main
  "Generate Mandelbrot fractal and check how much it takes to generate one"
  [& args]
  (let [width 1600
        height 900
        x0 (/ (* 2.0 (- width)) height)
        y0 2.0
        x1 (/ (* 2.0 width) height)
        y1 (- 2.0)]
    ; do test run
    (let [fractal (mandelbrot-fractal width height x0 y0 x1 y1)
          file-name "mandelbrot.clj.ppm"
          contents (reduce (fn [outlet x]
                             (str outlet " " (if (= x iter-limit) "1" "0")))
                           (str "P1 " width " " height)
                           fractal)]
      (spit file-name contents))
    ; TODO execute tests
  ))
