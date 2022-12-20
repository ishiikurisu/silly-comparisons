(ns mandelbrot.core
  (:gen-class)
  (:require [clojure.string :refer [join]]))

(def rep-limit 100)
(def iter-limit 1000)

(defn- screen-to-complex-plane [i j pd x0 y0]
  [(+ x0 (/ i pd))
   (+ y0 (/ (- j) pd))])

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
    (->> (for [j (range h)
               i (range w)]
           [i j])
         (map (fn [[i j]]
                (screen-to-complex-plane i j pd x0 y0)))
         (map #(apply mandelbrot %)))))

(defmacro sectime
  [expr]
  `(let [start# (. System (currentTimeMillis))
         ret# ~expr]
     (prn (str "Elapsed time: " (/ (double (- (. System (currentTimeMillis)) start#)) 1000.0) " secs"))
     ret#))

(defn- now []
  (. System (currentTimeMillis)))

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
    #_(let [fractal (mandelbrot-fractal width height x0 y0 x1 y1)
          file-name "mandelbrot.clj.ppm"
          contents (->> fractal
                        (map #(if (= % iter-limit) " 1" " 0"))
                        join
                        (str "P1 " width " " height))]
      (spit file-name contents))
    ; execute tests
    (loop [reps rep-limit
           i 1
           average 0.0]
      (if (> i reps)
        (do
          (println "---")
          (println "language: clojure")
          (println (str "average duration: " average "s")))
        (let [start-time (now)
              fractal (mandelbrot-fractal width height x0 y0 x1 y1)]
          ; this is done so lazy loading does not interfere with the final result
          (spit "temp.end" fractal)
          (recur reps
                 (inc i)
                 (+ average (/ (- (-> (now)
                                      (- start-time)
                                      double
                                      (/ 1000.0))
                                  average)
                               i))))))))

