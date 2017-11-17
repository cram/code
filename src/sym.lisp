(load "../src/boot")
(reload "../src/summary")

(defthing sym summary
  (most 0) (mode) (_ent) (_w)
  (cnt (make-hash-table)))

(defmethod add1 ((x sym) y)
  (with-slots (most mode cnt _w _ent) x
    (let* ((new (incf (gethash y cnt 0))))
      (if (> new most)
          (setf _ent nil
                _w   nil
                most new
                mode y)))))
  
(defun sym* (lst &optional (f #'identity))
  (adds (make-instance 'sym) lst f))

(defmethod copy ((old sym))
  (with-slots (cnt) old
    (let ((h   (make-hash-table))
          (new (make-instance 'sym)))
      (copier old new n most mode _ent)
      (dohash (k v cnt new)
        (setf (gethash k (slot-value new 'cnt)) v)))))

(defmethod print-object ((x sym) src)
  (with-slots (n most mode _ent cnt) x
    (format src "~a" 
            `(sym
              (n     . ,n)     (most . ,most)
              (mode . ,mode)   (_ent  . ,_ent)
              (cnt  . ,(hash-table-count cnt))))))

(defmethod ready ((x sym) &aux (e 0) w)
  (with-slots (_ent cnt n _w) x
    (unless _w
      (dohash (k v cnt)
        (let ((p (/ v n)))
          (push (cons (/ v n) k) w)
          (decf e (* p (log p 2)))))
      (setf _ent e
            _w   (sort w #'> :key #'first)))))

(defmethod ent ((x sym))
  (ready x)
  (? x _ent))

(defmethod any ((x sym) &aux v k (n (randf)))
  (ready x)
  (let ((lst  (? x _w)))
    (while (and lst (> n 0))
      (setf  v   (caar lst)
             k   (cdar lst)
             n   (- n v)
             lst (cdr lst)))
             
    k))

