#|

## Loading

|#
(load "../src/boot")
(reload "../src/summary")
#|

## Samples

RLeservoir sampling.

|#

(defthing sample summary
  (now   -1)
  (sorted nil)
  (most   64)
  (all))

(defmethod initialize-instance :after ((x sample) &key)
  (setf (? x all)
        (make-array (? x most) :initial-element nil)))

(defmethod add1 ((x sample) y )
  (with-slots (now most n all sorted)  x
    (setf sorted nil)
    (cond ((< now (1- most))
           (setf (aref all (incf now)) y))
          ((< (randf) (/ now n))
           (setf (aref all (randi now)) y)))))

(defmethod contents ((x sample))
  (coerce (subseq (? x all) 0 (1+ (? x now))) 'list))

(defmethod median ((x sample))
  (let* ((lst (sorted-contents x))
         (n   (length lst))
         (mid  (floor n 2)))
    (if (oddp n)
        (nth  mid lst)
        (/ (+ (nth (1- mid) lst)
              (nth mid lst))
           2))))

(defmethod sorted-contents ((x sample)) 
  (if (? x sorted)
      (contents x)
      (let ((ordered (sort (contents x) #'<)))
        (doitems (one n ordered)
            (setf (aref (? x all) n) one))
        (setf (? x sorted) t)
        ordered)))

(defmethod tiles ((x sample) &key (jump 20) (start 10))
  (let* ((lst   (sorted-contents x))
         (n     (? x now))
         (jump  (1+ (floor (* (/ jump   100) n))))
         (now   (1+ (floor (* (/ start  100) n))))
         (out))
    (print `(jump ,jump now ,now))
    (while (< now n)
      (push (aref (? x all) now) out)
      (incf now jump))
    (reverse out)))
    
(defun sample* (lst &optional (f #'identity))
  (adds (sample0) lst f))

(defmethod copy ((old sample))
  (let ((new (sample0)))
    (copier old new now sorted most n)
    (setf (slot-value new 'all)
          (copy-list (slot-value old 'all)))))
     
(defmethod print-object ((x sample)  src)
  (with-slots (now sorted most n all) x
    (format src "~a"
            `(sample (n   . ,n)    (sorted . ,sorted)
                     (most. ,most) (now    . ,now)
                     (all . ,(length all))))))

(defmethod any ((x sample))
  (aref (? x all)
        (randi
         (1- (length (? x all))))))
