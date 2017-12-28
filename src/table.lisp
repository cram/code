(defstruct table  
  (id (id+))
  name cols egs )

(defun someCols (tab fn)
  (select #'(lambda (x) (funcall fn (col-name x)))
          (table-cols tab)))

(defmemo table-more  (tab) (someCols tab #'more))
(defmemo table-less  (tab) (someCols tab #'less))
(defmemo table-klass (tab) (someCols tab #'klass))
(defmemo table-num   (tab) (someCols tab #'num)) 
(defmemo table-sym   (tab) (someCols tab #'sym))

(defun table-klassCol (tab)
  (car (table-klass tab)))

(defstruct row 
  (id (id+))
  table cells)

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
    (handle1Row (tab cells)
                (let ((row (make-row :table tab
                                     :cells (l->a cells))))
                     (push row (table-egs tab))
                     (dolist (col (table-cols tab))
                       (add col (row-cell row col)))))
    )
   ;; now we can begin
   (doitems (txt pos cols)
     (if (not (skip txt))
         (push (makeColumn txt pos tab)
               (table-cols tab))))
   (dolist (eg egs)
     (if (goodRow tab eg)
         (handle1Row tab eg)))
   tab))

(defun score (tab)
  (let ((klasses (sym-keys (table-klassCol tab))))
    (dolist (row (table-egs tab))
      (dolist (col (table-sym tab))
        (dolist (val (sym-keys col))
          (dolist (predicted klasses)
            (results+ (sym-results col)
                      (row-klassValue row)
                      predicted)))))))


