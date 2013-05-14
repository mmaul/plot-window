(in-package #:plot-window)

(define-javascript-library d3js () "http://d3js.org/d3.v3.min.js")

(defun d3js-example-1 ()
  (ps-eval-in-client
    (with-js-libraries (d3js)
      (chain ($ :body) (empty)) ;; clear the screen
      (chain ($ :body)          ;; add a svg panel
             (append "<svg>"))
      (chain d3 (select :svg) (attr :width 300) (attr :height 200))
      (flet ((sin-wave (amplitude)
               (loop for i from 1 to 40 
                  collect (create :x i
                                  :y (* amplitude (sin (/ i 2)))))))

        (let ((dx (lambda (d)
                    (let ((f (chain d3 scale (linear)
                                    (domain '(1 40)) (range '(10 290)))))
                      (funcall f (@ d x)))))
              (dy (lambda (d)
                    (let ((f (chain d3 scale (linear)
                                    (domain '(-10 10)) (range '(10 190)))))
                      (funcall f (@ d y)))))
              (x (chain d3 ;; A selection of N circles
                        (select :svg)
                        (select-all :circle)
                        (data (sin-wave 10)))))
          (flet ((f (d) (random 20))) ;; points in a pile
            (chain x 
                   (enter)
                   (append :circle)
                   (attr :r 3)
                   (attr :fill :lightgray)
                   (attr :cx #'f)
                   (attr :cy #'f)))
          (chain x ;; sweep into the 1st sin wave
                 (transition)
                 (delay 300)
                 (attr :r 3)
                 (attr :cx dx)
                 (attr :cy #'dy)
                 (attr :fill :cornsilk)
                 (attr :stroke :cornflowerblue))
          (chain x
                 (data (sin-wave -10)) ;; sweep into a 2nd sin wave
                 (transition)
                 (delay 1250)

                 (attr :fill :darkgray)
                 (attr :cx #'dx)
                 (attr :cy #'dy)))))))


