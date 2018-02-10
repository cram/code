(defparameter *tests* nil)

(defmacro deftest (name params  doc &body body)
  "Create a defun, adding it name to the list of *tests*."
  (let ((s "----------------------------"))
    `(progn
       (unless (member ',name *tests*) (push ',name *tests*))
       (defun ,name ,params ,doc
              (format t "~&; ----| ~a |~a~%" ',name ,s )
              (format t "; ~a~%" ,doc)
              ,@body))))

(let ((pass 0)  
      (fail 0)) 
  (defun test (want got)
    "Run one test, comparing 'want' to 'got'."
    (labels  
	((white (c) ; returns nil if 'c' is not white space
	   (member c '(#\# #\\ #\Space #\Tab #\Newline
		       #\Linefeed #\Return #\Page) :test #'char=))
	 (whiteout (s)  ; remove all white space
	   (remove-if #'white s)) 
	 (samep (x y) ; true if strings of x&y, sans whitespace, are the same
	   (string= (whiteout (format nil "~(~a~)" x)) 
		    (whiteout (format nil "~(~a~)" y)))))
      (cond ((samep want got) (incf pass)
                              (format t "!"))
	    (t                (incf fail)
			      (format t "~&; fail : expected ~a~%" want)))
      got))

  (defun tests ()
    "Run all the tests in *tests*."
    (labels ((run (x) (format t "~&;testing  ~a~%" x) (funcall x)))
      (when *tests*
	(setf fail 0 pass 0)
	(mapcar #'run (reverse *tests*))
	(format t "~%~%~%~%; pass : ~a = ~5,1f% ~%; fail : ~a = ~5,1f% ~%"
		pass (* 100 (/ pass (+ pass fail)))
		fail (* 100 (/ fail (+ pass fail)))))))
  )

