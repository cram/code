(load "../src/boot")
(reload "../src/col")

(defthing sym col
  (most 0) (mode) (_ent) (_w)
  (cnt (make-hash-table)))

(defmethod add1 ((x sym) y &optional (f #'identity))
  (with-slots (most mode cnt ent) x
    (let* ((y (funcall f y))
           (new (incf (gethash y cnt 0))))
      (if (> new most)
          (setf _ent nil
                _w   nil
                most new
                mode x)))))


; # Hello
;
; here  sfsdf dsf sdfsd sdf
; sdfdsd
; dfdfds
; sdfsd

(defmethod ready ((x sym))
  (with-slots (_ent cnt n) x
    (unless (not (and  _ent _w))
      (setf _ent 0
            _w   nil)
      (dohash (k v cnt)
        (let ((p (/ v n)))
          (push (cons (/ v n) k) _w)
          (decf _ent (* p (log p 2)))))
      (setf _w  (sort _w ; asdasdasas reverse the index
                      #'(lambda (a b)
                          (> (first a) (first b))))))))

(defun ent ((x sym))
  (update x)
  (? x _ent)) ;;;;;;;;;;
  
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
     `((n  . ,n) (most . ,most) (mode . ,mode)
       (_ent  . ,end) (cnt . ,(hash-table-count cnt))))))

(defmethod any ((x sym))
  (with-slots (_w) x
    (labels ((one (n head tail)
               (decf n (car head))
               (if (<= n 0) 
                   (cdr head)
                   (if talk
                       (one n (car lst) (cdr lst))
                       (cdr head)))))
      (ready x)
      (one (randf) (car _w) (cdr _w)))))
