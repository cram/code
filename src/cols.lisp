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

;(defun col-vals (col)
 ; (loop for key being the hash-keys of 
  ;     (sym-cnt (col-has col))
   ;  collect key))

(defmethod valid ((n num) x)
  (assert (numberp x) (x) "Not a number ~a" x))

(defmethod valid ((s sym) x)
  (declare (ignore s x)))
     
(defmethod add1 ((n num) x)
  (incf (num-n n))
  (push x (num-all n)))

(defmethod add1 ((s sym) x)
  (with-slots (most mode cnt n) s
    (incf n)
    (let* ((new (incf (gethash x cnt 0))))
      (if (> new most)
          (setf most new
                mode x)))))

;;;;;;;;;;;;;;;;;;;;;;;;;
(defthing col thing
  (n 0) (name) (pos) (table) (has (make-hash-table)))

(defthing syms col)

(defthing nums col)

(defmethod another ((c syms)) (make-sym))
(defmethod another ((c nums)) (make-num))

(defmethod  add ((c col)  x row)
  (with-slots (n table has) c
    (unless (eql x #\?)
      (let* ((whenx  (or (gethash has x)
                         (another c))))
        (setf (gethash has x) whenx)
        (incf n)
        (valid whenx x)
        (add1 whenx (row-klass table row)))))
  x)
