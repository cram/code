(defpackage :fft
    (:use :common-lisp))

(in-package :fft)

(defvar *tests* nil)

(defmacro deftest (name params  &optional (doc "") &body body)
  "Create a defun, adding it name to the list of *tests*."
  `(progn
     (unless (member ',name *tests*) (push ',name *tests*))
     (defun ,name ,params ,doc
            (format t "~&~%;;; ~a~%" ',name )
            (format t "; ~a~%" ,doc)
            ,@body
            (terpri))))

(let ((pass 0) (fail 0)) 
  (defun ok (want got)
    (cond ((equalp want got) (incf pass))
          (t (incf fail)
             (format t "~&; fail : expected ~a~%" want))))
  
  (defun tests ()
    (when *tests*
      (mapc #'funcall  (reverse *tests*))
      (format t "~&~%; pass : ~a = ~5,1f% ~%; fail : ~a = ~5,1f% ~%"
              pass (* 100 (/ pass (+ 0.000000001 pass fail)))
              fail (* 100 (/ fail (+ 0.000000001 pass fail)))))))
    
(deftest _1 () (ok 1 1))
(deftest _2 () (ok 2 1))
        
;;;; command line
(defun bye ()
  #+sbcl (sb-ext:exit)
  #+clisp (ext:exit)
  #+allegro (excl:exit))

(defun command-line ()
  (cdr
   #+clisp ext:*args*
   #+sbcl sb-ext:*posix-argv*
   #+allegro (sys:command-line-arguments)))
  
(defun run (argv)
  "just symbols & keywords & numbers (not strings or lists)"
  (let* ((com  (and argv (mapcar 'read-from-string argv)))
         (fn   (and com (car com)))
         (args (and com (cdr com))))
    (if fn
        (apply fn args)
        (tests))))

(run (command-line))
(bye)
