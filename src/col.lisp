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

(defvar *ids* 0)

  (defstruct col 
      (id (incf *ids*))
      (n 0) name pos table)

(defstruct (sym (:include col)) 
    (most 0) (mode) (hash (make-hash-table)))

(defstruct (num (:include col)) 
    all)

(defmethod print-object ((c col) stream)
  (with-slots (name pos) c
    (format stream "~a" `(,(type-of c)
                      (name ,name)
                      (pos  ,pos)
                      ))))

(defmethod valid ((n num) x)
  (assert (numberp x) (x) "Not a number ~a" x))

(defmethod valid ((s sym) x)
  (declare (ignore s x)))
     
(defmethod add1 ((n num) x)
  (incf (num-n n))
  (push x (num-all n)))

(defmethod add1 ((s sym) x)
  (with-slots (most mode hash n ) s
    (incf n)
    (let* ((new (incf (gethash x hash 0))))
      (if (> new most)
          (setf most new
                mode x)))))

(defmemo sym-keys (s)
   (hash-keys (sym-hash s)))

(defun add (col x)
  (unless (eql col #\?)
    (incf (col-n col))
    (valid col x)
    (add1 col x))
  x)

(defstruct span hi lo name)

(defmethod range ((s sym) x)
  (declare (ignore s))
  x)

(defun ranges (x) (noop x))

(defmethod range ((n num) x)
  (let (last)
    (dolist (r (ranges n))
      (setf last r)
      (if (<= (span-lo r) x (span-hi r))
	(return-from range (span-name r))))
    (span-name last)))


