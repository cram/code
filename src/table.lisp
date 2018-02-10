;-----------------------------------------
; table stuff
(defstruct table  
  (id (id+))
  name cols egs)

(defun someCols (tab fn)
  (select #'(lambda (x) (funcall fn (col-name x)))
          (table-cols tab)))

(defone table-more  (tab) (someCols tab #'more))
(defone table-less  (tab) (someCols tab #'less))
(defone table-klass (tab) (someCols tab #'klass))
(defone table-num   (tab) (someCols tab #'num)) 
(defone table-sym   (tab) (someCols tab #'sym))

(defun table-klassCol (tab)
  (car (table-klass tab)))


;------------------------------------
; row
(defstruct row 
  (id (id+))
  table cells)

(defun row-cell (row col)
  (aref (row-cells row) (col-pos col)))

(defone row-klassValue (row)
  (aref
   (row-cells row)
   (col-pos
    (table-klassCol 
     (row-table row)))))

(defone row-klassRange (row)
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

;------------------------------------
(defun data (&key name cols egs
             &aux (tab (make-table :name name)))
  "Build table for name, col, egs"
  (labels 
   ((okCol (txt)
           (not (skip txt)))
    (okRow (tab row) 
           (assert (eql (length row)
                        (length (table-cols tab)))
                   (row) "wrong length ~a" row)
           t)
    (col+ (txt pos tab)
          (funcall
           (if (numeric txt) #'make-num #'make-sym)
           :name  txt 
           :pos   pos 
           :table tab))
    (row+ (tab cells)
          (let ((row (make-row :table tab
                               :cells (l->a cells))))
               (push row (table-egs tab))
               (dolist (col (table-cols tab))
                 (add col (row-cell row col)))))
    )
   ;; now we can begin
   (doitems (txt pos cols)
     (if (okCol txt)
         (push (col+ txt pos tab)
               (table-cols tab))))
   (dolist (eg egs)
     (if (okRow tab eg)
         (row+ tab eg)))
   tab))

;--------------------------------------
(defun col-val-results (tab)
  (let ((out (make-hash-table :test #'equal))) 
       (print out)
       (dolist (col (table-sym tab))
         (dolist (val (sym-keys col))
           (setf (gethash `(,(col-name col) ,val) out)
                 (results0 (sym-keys (table-klassCol tab))))))))

(defun score (tab)
  (let ((scores (col-val-results tab)))
       (print 1)
    (dolist (row (table-egs tab))
      (dolist (col (table-sym tab))
        (dolist (val (sym-keys col))
          (whatif (gethash `(,(col-name col) ,val) scores)
                  (row-klassValue row)))))))


