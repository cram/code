
(defconstant +keeping+ 
  '(num  ; independent variables, numerics 
    sym  ; independent variables, symbolic
    klass;   dependent variables, symbolic
    more ;   dependent variables, numeric
    less ;   dependent variables, numeric
    )
  "Keep some special columns in a seperate list.
   For every kept column, there must be an arity/1 
   function of the same name to recognizes that 
   kind of column.")
  
(eval `(defstruct table 
         name cols egs klassNames 
         ,@+keeping+))
             
(defun klass! (tab)
  (when  (table-klass tab)
    (car (table-klass tab))))

(defun klassNames  (tab)
  (col-vals (klass! tab)))

(defun abcd0 (tab)
  (results0 (klassNames tab)))

(defun data (&key name cols egs &aux (pos -1))
  (let ((tab (make-table :name name)))
    (labels 
        ((makeNewColumn (colname pos)
           (make-col :name colname :pos pos
                     :has (if (numeric colname)
                              (make-num)
                              (make-sym))))
         (handle1HeaderName (tab col)
           (push col (table-cols tab))
           (dolist (one +keeping+)
             (if (funcall one (col-name col))
                 (push col (slot-value tab one)))))
         (handle1Row (tab row)
           (assert (eql (length row)
                        (length (table-cols tab)))
                   (row) "wrong length ~a" row)
           (push row (table-egs tab))
           (dolist (col (table-cols tab))
             (add (col-has col)
                  (aref row (col-pos col)))))
         (doAnyFinalStuff (tab)
           (setf (table-klassNames tab)
                 (klassNames tab))))
      (dolist (colname cols)
        (incf pos)
        (unless (skip colname)
          (handle1HeaderName tab 
            (makeNewColumn colname pos))))
      (dolist (eg egs)
        (handle1Row tab (l->a eg)))
      (doAnyFinalStuff tab))
    tab))

