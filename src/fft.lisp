#|
; load without running tests
(load "fft.lisp")

; load with running tests
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
(load "hash")
(load "strings")
(load "fun")
;;; load stuff for fft
(load "abcd")
(load "col")
(load "table")
(load "main")

(defun egs (&key (file "weathernumerics"))
  (let ((g (format nil "../data/~a.lisp" file)))
    (assert  (probe-file g) (g) "missing file ~a" g)
    (with-open-file
        (in g :direction :input)
      (apply #'data (read in))))) ;;

(deftest weather ()
  (let* ((tab (egs :file "weathernumerics"))
         (kcol (table-klassCol tab)))
    (test (length (table-egs tab)) 14)
    (test (sym-keys kcol) '(no yes))))


(deftest keyTest (&key (bb 2) (aa 10))
  (o aa bb)
  (print (* bb aa)))

#+tdd (main)
