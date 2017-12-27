
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
         ,@+keeping+))
             
(defun klass! (tab)
  (when  (table-klass tab)
    (car (table-klass tab))))

(defun row-klass (tab row)
  (aref row (col-pos (klass! row))))

(defun klassNames  (tab)
  (col-vals (klass! tab)))

(defun table-results0 (tab)
  (results0 (col-vals (klass! tab))))
  
(defun goodRow (tab row)
  (assert (eql (length row)
               (length (table-cols tab)))
          (row) "wrong length ~a" row)
  t)

(defun columnKeeper (tab pos colname)
  (let* ((col (make-instance
		(if (numeric colname) 'nums 'syms)
		:name colname 
		:pos pos 
		:table tab)))
    (push col (table-cols tab))
    (dolist (one +keeping+)
      (if (funcall one (col-name col))
          (push col (slot-value tab one))))))
                 
(defun handle1Row (tab row)
  (push row (table-egs tab))
  (dolist (col (table-cols tab))
      (adds col val))))

(defun data (&key name cols egs)
  (let ((tab  (make-table :name name)))
    (doitems (colname pos cols)
        (if (not (skip colname))
            (columnKeeper tab pos colname)))
    (dolist (eg egs)
      (if (goodRow tab row)
          (handle1Row tab (l->a eg))))
    tab))
