(defstruct table name cols egs klassNames
                 num sym klass more less)

(defun data (&key name cols egs &aux (pos -1))
  (let ((tab     (make-table :name name))
        (keeping '(num sym klass more less)))
    (labels 
        ((col+ (colname pos)
           (make-col :name colname 
                     :pos  pos
                     :has  (if (numeric colname)
                               (make-num)
                               (make-sym))))
         (header+ (tab col)
           (push col (slot-value tab 'cols))
           (dolist (one keeping)
             (if (funcall one (col-name col))
                 (push col (slot-value tab one)))))
         (row+ (tab row)
           (push row (table-egs tab))
           (dolist (col (table-cols tab))
             (add (col-has col)
                  (aref row (col-pos col)))))
         (complete (tab)
           (setf (slot-value tab 'klassNames)
                 (mapcar #'col-name (table-klass
      ;; begin processing
      (dolist (colname cols)
        (unless (skip colname)
          (header+ tab 
                   (col+ colname (incf pos)))))
      (dolist (eg egs)
        (row+ tab (l->a eg)))
      (complete tab))
    tab))

(defun klass (tab)
  (when  (table-klass tab)
    (car (table-klass tab))))


