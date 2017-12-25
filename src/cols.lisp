;;;; Columns
(defun prefix (x y) (eql (char (symbol-name x) 0) y))
(defun skip     (x) (prefix x #\?))
(defun more     (x) (prefix x #\>))
(defun less     (x) (prefix x #\<))
(defun klass    (x) (prefix x #\!))
(defun num      (x) (prefix x #\$))
(defun goal     (x) (or (klass x) (less x) (more x)))
(defun numeric  (x) (or (num x)   (less x) (more x)))
(defun sym      (x) (and (not (num x)) (not (goal x))))

(defstruct sym (n 0) (most 0) (mode) (cnt (make-hash-table)))
(defstruct num (n 0) all)
(defstruct col name has pos)

; derived col items
(defun col-vals (col)
  (loop for key being the hash-keys of 
       (sym-cnt (col-has col))
     collect key))

(defmethod add1 ((col num) x)
  (push x (num-all col)))

(defmethod add1 ((col sym) x)
  (with-slots (most mode cnt) col
    (let* ((new (incf (gethash x cnt 0))))
      (if (> new most)
          (setf most new
                mode x)))))

(defmethod valid ((col num) y)
  (assert (numberp y) (y) "Not a number ~a" y))

(defmethod valid ((col sym) y)
  (declare (ignore col y))
  t)

(defun add (col x)
  (unless (eql x #\?)
    (valid col x)
    (incf (slot-value col 'n))
    (add1 col x))
  x)


