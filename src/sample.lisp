#|

## Loading

|#
(load "../src/boot")
(reload "../src/col")
#|

## Samples

RLeservoir sampling.

|#

 (defthing sample col
    (now   -1)
    (sorted nil)
    (most   64)
    (all    (make-array 64 :initial-element nil) ))

(defun sample0 (&optional (max 256))
  (let ((x (make-instance 'sample :most max)))
    (setf (? x all)
           (make-array max :initial-element  nil))
    x))

(defmethod add1 ((x sample) y &optional (f #'identity))
  (with-slots (now most n all sorted)  x
    (setf sorted nil
          y      (funcall f y))
    (cond ((< now (1- most))
           (setf (aref all (incf now)) y))
          ((< (randf) (/ now n))
           (setf (aref all (randi now)) y)))))

(defmethod contents ((x sample))
  (coerce (subseq (? x all) 0 (1+ (? x now))) 'list))

(defmethod sorted-contents ((x sample)) 
  (if (? x sorted)
      (contents x)
      (let ((ordered (sort (contents x) #'<)))
        (doitems (one n ordered)
            (setf (aref (? x all) n) one))
        (setf (? x sorted) t)
        ordered)))
    
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
