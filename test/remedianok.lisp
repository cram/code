(in-package :cram)
(needs "../src/remedian"
       "../src/sample")

(deftest remedian0 ()
  "diffs"
  (dolist (i '(1 33 555 7777 88888 999999))
    (let ((n (expt 10 5))
          all
          (s (make-instance 'sample))
          (r (make-instance 'remedian)))
      (reset-seed i)
      (dotimes (i n)
        (let ((one (expt (randf) 2)))
          (add r one)
          (add s one)
          (push one all)
          ))
      (setf all (sort all #'<))
      (let ((actual (nth (floor n 2) all))
            (predicted1 (middle r))
            (predicted2 (median s)))
        (format t "r ~a act ~a remed ~a diff ~a sample ~a diff ~a~%"
                i actual predicted1 
                (floor (* 100 
                          (/ (- actual predicted1)
                             actual)))
                predicted2
                (floor (* 100 
                          (/ (- actual predicted2)
                             actual))))))))
    


