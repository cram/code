(load "../src/boot")
(reload "../src/col")

(defthing sym col
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
        (setf (gethash k (slot-value new 'cnt))  v)))))

(defmethod print-object ((x sym) src)
  (with-slots (n most mode _ent cnt) x
    (format
     src "~a"
     `((n     . ,n)     (most . ,most)
       (mode . ,mode)   (_ent  . ,_ent)
       (cnt  . ,(hash-table-count cnt))))))

(defmethod ready ((x sym))
  (with-slots (_ent cnt n _w) x
    (unless _w
      (setf _ent 0
            _w   nil)
      (dohash (k v cnt)
        (let ((p (/ v n)))
          (push (cons (/ v n) k) _w)
          (decf _ent (* p (log p 2)))))
      (setf _w  (sort _w ; asdasdasas reverse the index
                      #'(lambda (a b)
                          (> (first a) (first b))))))))

(defmethod ent ((x sym))
  (ready x)
  (? x _ent))

(defmethod any ((x sym))
  (ready x)
  (with-slots (_w) x
    (labels
        ((one (n lst)
           (let ((v    (caar lst))
                 (k    (cdar lst))
                 (tail (cdr  lst)))
             (decf n v)
             (cond ((<= n 0)  k)
                   (tail      (one n tail))
                   (t         k)))))
      (one (randf) _w))))
