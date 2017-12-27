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
(load "fun")
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
      (apply #'data (read in))))) ;;

(deftest _weather ()
  (egs "weathernumerics"))

(defstruct range 
  key
  (cost-observe 0)
  (cost-change  0)
  klass abcd objs)

(defstruct range-key val pos)
(defun range-pos (x) (col-pos (range-col x))

(defun ranges (tab &aux (all (make-hash-table)))
  (dolist (col (table-sym tab) all)    
    (dolist (val (col-vals col))
      (let ((key (make-range-key :pos (col-pos val)  
                                 :val val)))
        (setf (gethash all key)
              (make-range :val  val
                          :col  col
                          :abcd (abcd0 tab)))))))

(defun abouts (tab)
  (let ((all     (make-hash-table :test #'equal)) ; all the results
        (klasses (klassNames tab))) ; all thee class ames
    (labels 
        (
  (let* ((tab  (egs file)))
   
        (o pos val))))))

(deftest keyTest (&key (bb 2) (aa 10))
  (o aa bb)
  (print (* bb aa)))

#+tdd (main)
