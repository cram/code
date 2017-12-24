#|
; load without running tests
(load "fft.lisp"
(let ((*features* (cons :production *features*)))
  (load "fft.lisp"))
|#

(defpackage :fft
    (:use :common-lisp)
    (:export #:main))

(in-package :fft)

(load "macros") 
(load "tests")
(load "lists")
(load "cols")
(load "table")
(load "main")

(defun egs (f)
  (let ((g (format nil "../data/~a.lisp" f)))
    (assert  (probe-file g) (g) "missing file ~a" g)
    (with-open-file
        (in g :direction :input)
      (apply #'data (read in)))))



(print (egs "weathernumerics"))

#+tdd (main)
