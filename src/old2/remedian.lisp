(in-package :cram)

(uses "../src/summary")

(defthing remedian summary
  (all)
  (more)
  (mid)
  (most 64))

(defmethod update ((x remedian))
  (with-slots (all mid most) x
    (setf mid (nth (floor most 2) 
                   (sort all #'<))
          all nil)))

(defmethod  add1 ((x remedian) y)
  (with-slots (all most mid more) x
    (cond 
      ((< (length all) most)
       (push y   all))
      (t 
       (update x)
       (unless more
         (setf more (make-instance 'remedian)))
       (add more mid)))))

(defmethod middle ((x remedian) &optional b4)
  (with-slots (more mid) x
    (cond (more  (middle more mid))
          (mid   mid)
          (t     b4))))
