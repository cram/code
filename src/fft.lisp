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

;;; load standard stuff
(load "macros") 
(load "tests")
(load "rand")
(load "lists")
(load "strings")
;;; load stuff for fft
(load "abcd")
(load "cols")
(load "table")
(load "main")

(defun egs (f)
  (let ((g (format nil "../data/~a.lisp" f)))
    (assert  (probe-file g) (g) "missing file ~a" g)
    (with-open-file
        (in g :direction :input)
      (apply #'data (read in)))))

(deftest _weather ()
  (egs "weathernumerics"))

(deftest tmp (&key (file "weathernumerics"))
  (let* ((tab  (egs file))
         (seen (results0 (klassNames tab))))
    (dolist (col (table-sym tab))
      (let ((pos (col-pos col)))
        (dolist (val (col-vals col))
          (o pos val))))))

#+tdd (main)
