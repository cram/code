(in-package :cram)
(uses "summary"
      "sample")

(defthing num summary
  (any (make-instance 'sample))
  (mu 0) (m2 0) (sd 0) (rank 0)
  (lo most-positive-fixnum)
  (hi most-negative-fixnum))

(defmethod add1 ((x num) y)
  (with-slots (hi lo n mu m2 sd any) x
    (let* ((delta (- y mu)))
      (add any y)
      (setf lo (min lo y)
            hi (max hi y)
            mu (+ mu (/ delta n))
            m2 (+ m2 (* delta (- y mu))))
      (if (> n 1)
          (setf sd (sqrt (/ m2 (- n 1))))))))

(defun num* (lst &optional (f #'identity))
  (adds (make-instance 'num) lst f))

(defmethod copy ((old num))
  (let ((new (make-instance 'num)))
    (copier old new n sd mu m2 lo hi)))
     
(defmethod print-object ((x num) src)
  (with-slots (n pos txt w mu sd lo hi) x
    (format src "~a"
     `(nump
       (n  . ,n)  (pos . ,pos) (txt . ,txt) (w  . ,w)
       (mu . ,mu) (sd . ,sd)  (lo  . ,lo)  (hi . ,hi)))))

(defmethod median ((x num))
  (median (? x any)))

(defmethod xpect ((x num) &optional (all 1))
  "return stadnard deviation, expressed as a ratio of 'all'"
  (* (slot-value x 'sd) (/ (slot-value x 'n) all)))

(defmethod any ((x num) &aux x1 x2 (w 1))
  (while (>= w 1)
      (setf x1 (- (* 2 (randf) 1))
            x2 (- (* 2 (randf) 1))
            w  (+ (* x1 x1) (* x2 x2))))
  (with-slots (mu sd) x
    (+ mu (* sd w x1 (sqrt (/ (* -2 (log w)) w))))))

