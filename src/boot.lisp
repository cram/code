(defpackage :cram
    (:use :common-lisp)
    (:export #:tests))

(in-package :cram)

(format t ";;; ../test/boot~%")

(defvar +paths+
	      '("."
		"../src"
	        "../test"
	        "../data"))

(let ((seen))  
  (defun uses (&rest lst)
    #+playing
    (labels (
      (use1 (f)
	    (dolist (path +paths+)
	      (let* ((g (format nil "~a/~a" path f))
		     (h (format nil "~a.lisp" g)))
		(if (probe-file h)
		  (handler-bind
                    ((style-warning #'muffle-warning))
                    (format t ";;; ~a~%" g)
                    (load g)
                    (push f seen)
		    (return-from use1)))))))
      (dolist (f lst)
	(when (not (member f seen :test #'equalp))
	  (use1 f))))))

(defmacro o (&rest l)
  "Print a list of symbols and their bindings."
  (let ((last (gensym)))
    `(let (,last)
       ,@(mapcar #'(lambda(x) `(setf ,last (oprim ,x))) l)
       (terpri)
       ,last)))

(defmacro oprim (x)
  "Print a thing and its binding, then return thing."
  `(progn (format t "~&[~a]=[~a] " ',x ,x) ,x))

(defparameter *tests* nil)

(defmacro deftest (name params  &optional (doc "") &body body)
  "Create a defun, adding it name to the list of *tests*."
  `(progn
     (unless (member ',name *tests*) (push ',name *tests*))
     (defun ,name ,params ,doc
            (format t "~&~%;;; ~a~%" ',name )
            (format t "; ~a~%" ,doc)
            ,@body
            (terpri))))

(let ((pass 0)  
      (fail 0))
  
  (defun test (want got)
    "Run one test, comparing 'want' to 'got'."
    (labels  
        ((white (c) (member c '(#\# #\\ #\Space #\Tab #\Newline
                              #\Linefeed #\Return #\Page) 
                              :test #'char=))
         (whiteout (s)  (remove-if #'white s)) 
         (samep (x y)   (equalp
                         (whiteout (format nil "~(~a~)" x)) 
                         (whiteout (format nil "~(~a~)" y)))))
      (cond ((samep want got) 
             (incf pass))
            (t  
             (incf fail)
             (format t "~&; fail : expected ~a~%" want)))
      got))
  
  (defun tests ()
    "Run all the tests in *tests*."
    (when *tests*
      (setf fail 0 pass 0)
      (mapc #'funcall (reverse *tests*))
      (format t "~&~%; pass : ~a = ~5,1f% ~%; fail : ~a = ~5,1f% ~%"
              pass (* 100 (/ pass (+ 0.000000001 pass fail)))
              fail (* 100 (/ fail (+ 0.000000001 pass fail))))))
  )
