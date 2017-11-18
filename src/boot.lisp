(unless  (fboundp 'reload)
  
  (let ((seen))  
    (defun reload (f)
      (when (not (member f seen :test #'equalp))
        (push f seen)
        (handler-bind
            ((style-warning #'muffle-warning))
          (format t ";;; ~a~%" f)
          (load f)))))
  
  (defparameter *tests* nil)

  (defmacro deftest (name params  &optional (doc "") &body body)
    "Create a defun, adding it name to the list of *tests*."
    `(progn
       (unless (member ',name *tests*) (push ',name *tests*))
       (defun ,name ,params ,doc
              (format t "~%;;; ~a~%" ',name )
              (format t "; ~a~%" ,doc)
              ,@body
              (terpri))))
  
  (let ((pass 0)  
        (fail 0))
    
    (defun test (want got)
      "Run one test, comparing 'want' to 'got'."
      (labels  
          ((white (c)     (member c '(#\# #\\ #\Space #\Tab #\Newline
                                     #\Linefeed #\Return #\Page) :test #'char=))
           (whiteout (s)  (remove-if #'white s)) 
           (samep (x y)   (whiteout (format nil "~(~a~)" x)) 
                          (whiteout (format nil "~(~a~)" y))))
        (cond ((samep want got) (incf pass))
              (t                (incf fail)
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
) 
