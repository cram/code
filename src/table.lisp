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

<<<<<<< HEAD
;; (defun score (memo tab col val  
;;               goal   ; the thing i care about
;;               row
;;               &optional (yes #'noop) (no  #'noop))
;;   (let ((actual  (row-klass tab row))
;;          (a 0) (b 0) 
;;         (c 0) (d 0))
;;     (dohash (val1 values (gethash memo (col-name col)))
;;       (dohash (klass count values) ;????
;;           (if (eql val1 val)
;;               (funcall yes goal klass row)
;;               (funcall no  goal klass row))
;;           (incf
;;            (if (eql val1 val)
;;                (if (eql goal actual) d c)
;;                (if (eql goal actual) b a))
;;            count)))
;;     (make-range :col col :val val :goal goal
;;                 :a a :b :c c :d d)))
                  
;; (defun handle1Row (tab row)
;;   (push row (table-egs tab))
;;   (dolist (col (table-cols tab))
;;     (let* ((pos    (col-pos col))
;;            (val    (aref row pos))
;;            (klass  (row-klass tab row))
;;            (key   `(,(col-name col) ,val ,klass))
;;            (counts (nestedHash key (table-memo tab)))) ; was keys
;;       (incf (gethash counts klass))
;;       (add (col-has col) val))))

;; (defun data (&key name cols egs)
;;   (let ((tab  (make-table :name name)))
;;     (doitems (colname pos cols)
;;         (if (not (skip colname))
;;             (columnKeeper tab pos colname)))
;;     (dolist (eg egs)
;;       (if (goodRow tab row)
;;           (handle1Row tab (l->a eg))))
;;     tab))
=======

>>>>>>> f10f4feb0ad7ad82a1050dbe3f6e2e98a6af706f
