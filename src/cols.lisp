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

(defun col-vals (col)
  (loop for key being the hash-keys of 
       (sym-cnt (col-has col))
     collect key))

(defmethod valid ((n num) x)
  (assert (numberp x) (x) "Not a number ~a" x))

(defmethod valid ((s sym) x)
  (declare (ignore s x)))
     
(defmethod add ((n num) x)
  (incf (num-n n))
  (push x (num-all n)))

(defmethod add ((s sym) x)
  (with-slots (most mode cnt n) s
    (incf n)
    (let* ((new (incf (gethash x cnt 0))))
      (if (> new most)
          (setf most new
                mode x)))))

(defmethod range ((s sym) x)
  (declare (ignore s))
  x)

(defmethod range ((n num) x)
  (let (last)
    (dolist (r (ranges s))
      (setf last r)
      (if (<= (range-lo r) x (range-h r))
	(return-from range (range-name r))))
    (range-name last)))

;;;;;;;;;;;;;;;;;;;;;;;;;
(defthing col thing
  (n 0) (name) (pos) (table) (has (make-hash-table)))

(defthing syms col)

(defthing nums col)

(defmethod another ((c syms)) (make-sym))
(defmethod another ((c nums)) (make-num))

(defmethod  adds ((c col)  x row); for each class do...
  (with-slots (n table has) c
    (unless (eql x #\?)
      (let* ((r  (range c x))
	     (whenx (or (gethash has r)
                        (another c))))
        (setf (gethash has r) whenx)
        (incf n)
        (valid whenx x)
        (add whenx (row-klass table row)))))
  x)
