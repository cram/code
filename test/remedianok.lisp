(in-package :cram)
(uses "../src/remedian"
      "../src/sample")

(deftest remedian0 ()
  "diffs"
  (let* ((loops1 10) 
         (loops2 (expt 10 2))
         (total  (* loops1 loops2))
         (d1 0)  (d2 0))
    (reset-seed 1)
    (dotimes (i loops1)
      (let (all
            (s (make-instance 'sample))
            (r (make-instance 'remedian)))
        (dotimes (j loops2)
          (let ((one (float (randi 1000))))
            (add r one)
            (add s one)
            (push one all)))
        (setf all (sort all #'<))
        (let ((actual (nth (floor loops2 2) all))
              (pred1  (middle r))
              (pred2  (median s)))
          (incf d1 (- actual pred1))
          (incf d2 (- actual pred2)))))
    (test t (< d1 d2))
    (format t 
       "d1: ~a~%d2: ~a~%remedian: ~a~%sample: ~a~%ratio: ~a ~%" 
       d1 d2
       (/ d1 total) (/ d2 total)
       (/ (/ d1 total) (/ d2 total)))))

