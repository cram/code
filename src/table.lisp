
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
 
;; programming note. any slot starting with "_"
;; is come common tedious join that we do once, then cache

(eval `(defstruct table 
         name cols egs 
         ,@+keeping+))

(defun table-klassCol (tab)
  (car (table-klass tab)))

(let ((id 0))
  (defstruct row 
        (id (incf id))
        table cells  ))

(defun row-cell (row col)
  (aref (row-cells row) (col-pos col)))

(defmemo row-klassValue (row)
   (aref
     (row-cells row)
     (col-pos
       (table-klassCol 
         (row-table row)))))

(defmemo row-klassRange (row)
   (range
     (table-klassCol (row-table row))
     (row-klassValue row)))

(defmethod print-object ((r row) stream)
  (with-slots (id cells ) r
    (format stream "~a" 
            `(,(type-of r)
               (id ,id)
               (cells  ,cells)
               ))))

(defun table-results0 (tab)
  (results0 (sym-keys (table-klassCol tab))))
  
(defun data (&key name cols egs
                  &aux (tab (make-table :name name)))
  (labels 
    ((goodRow (tab row) 
              (assert (eql (length row)
                           (length (table-cols tab)))
                      (row) "wrong length ~a" row)
              t)
     (makeColumn (txt pos tab)
                 (funcall
                   (if (numeric txt) #'make-num #'make-sym)
                   :name  txt 
                   :pos   pos 
                   :table tab))
     (columnKeeper (tab pos txt)
                   (let* ((col (makeColumn txt pos tab)))
                     (push col (table-cols tab))
                     (dolist (one +keeping+)
                       (if (funcall one (col-name col))
                         (push col (slot-value tab one))))))
     (handle1Row (tab cells)
                 (let ((row (make-row :table tab
                                      :cells (l->a cells))))
                   (row-klassRange row) 
                   (push row (table-egs tab))
                   (dolist (col (table-cols tab))
                     (add col (row-cell row col)))))
     )
    ;; now we can begin
    (doitems (txt pos cols)
             (if (not (skip txt))
               (columnKeeper tab pos txt)))
    (dolist (eg egs)
      (if (goodRow tab eg)
        (handle1Row tab eg)))
    tab))
