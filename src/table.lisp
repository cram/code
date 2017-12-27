
(defconstant +keeping+ 
  '(num  ; independent variables, numerics 
    sym  ; independent variables, symbolic
    klass;   dependent variables, symbolic
    more ;   dependent variables, numeric
    less ;   dependent variables, numeric
    )
  "Keep some special columns in a seperate list.
   For every kept column, there must be an arity/1 
   predictate of the same name that returns 't' if
   it recognizes that column name.")
  
(eval `(defstruct table 
         name cols egs 
         (memo (make-hash-table))
         ,@+keeping+))
             
(defun klass! (tab)
  (when  (table-klass tab)
    (car (table-klass tab))))

(defun row-klass (tab row)
  (aref row (col-pos (klass! row))))

(defun klassNames  (tab)
  (col-vals (klass! tab)))

(defun goodRow (tab row)
  (assert (eql (length row)
               (length (table-cols tab)))
          (row) "wrong length ~a" row)
  t)

(defun columnKeeper (tab pos colname)
  (let* ((ako (if (numeric colname)
                  #'make-num
                  #'make-sym))
         (col (make-col :name colname :pos pos 
                        :ako ako :table tab)))
    (push col (table-cols tab))
    (dolist (one +keeping+)
      (if (funcall one (col-name col))
          (push col (slot-value tab one))))))
   
(defstruct range col val goal a b c d)

(defun score (memo tab col val  
              goal   ; the thing i care about
              row
              &optional (yes #'noop) (no  #'noop))
  (let ((actual  (row-klass tab row))
         (a 0) (b 0) 
        (c 0) (d 0))
    (dohash (val1 values (gethash memo (col-name col)))
      (dohash (klass count values) ;????
          (if (eql val1 val)
              (funcall yes goal klass row)
              (funcall no  goal klass row))
          (incf
           (if (eql val1 val)
               (if (eql goal actual) d c)
               (if (eql goal actual) b a))
           count)))
    (make-range :col col :val val :goal goal
                :a a :b :c c :d d)))
                  
(defun handle1Row (tab row)
  (push row (table-egs tab))
  (dolist (col (table-cols tab))
    (let* ((pos    (col-pos col))
           (val    (aref row pos))
           (klass  (row-klass tab row))
           (key   `(,(col-name col) ,val ,klass))
           (counts (nestedHash keys (table-memo tab))))
      (incf (gethash counts klass))
      (add (col-has col) val))))

(defun data (&key name cols egs)
  (let ((tab  (make-table :name name)))
    (doitems (colname pos cols)
        (if (not (skip colname))
            (columnKeeper tab pos colname)))
    (dolist (eg egs)
      (if (goodRow tab row)
          (handle1Row tab (l->a eg))))
    tab))
