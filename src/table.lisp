
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
        table cells _klassValue _klassRange))

(defun row-cell (row col)
  (aref (row-cells row) (col-pos col)))

(defun row-klassValue (row)
  "cache long access to klass value"
  (with-slots (_klassValue table cells) row
    (or _klassValue
        (setf _klassValue
              (aref
                cells
                (col-pos
                  (table-klassCol 
                    table)))))))

(defun row-klassRange (row)
  "cache long access to klass range"
  (with-slots (_klassRange table) row
    (or _klassRange
        (setf _klassRange
              (range
                (table-klassCol table)
                (row-klassValue row))))))

(defmethod print-object ((r row) stream)
  (with-slots (id cells _klassValue _klassRange) r
    (format stream "~a" 
            `(,(type-of r)
               (id ,id)
               (cells  ,cells)
               (_klassValue ,_klassValue)
               (_klassRange ,_klassRange)
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

(defun rankRanges (tab)
  )
