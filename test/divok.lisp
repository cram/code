(in-package :cram)
(uses "../src/div")

(deftest ranges! ()
  "Want 3, then 5,  lists"
  (let* ((lst '(10 20 30 11 21 31 12 22
                32 13 23 33 14 24 34))
         (l5   (ranges lst :n  5))
         (l3   (ranges lst :n  3)))
    (print `(l5 ,l5))
    (print `(l3 ,l3))
    (test (length l5) 3)
    (test (length l3) 5)))

(deftest  superranges! ()
  "Want 3, then 5,  lists"
  (labels ((prep1 (n)
             (list n (cond ((< n 20) (randi 5))
                           ((< n 80) (+ 10 (randi 5)))
                           (t        (+ 100 (randi 5)))))))
    (let* ((lst  (loop for i from 1 to 1000 collect
                      (prep1 (randi 100)))))
      (multiple-value-bind  (sup unsup)
          (superranges lst)
        (format t "sup ~a unusp ~a~%" (length sup) (length unsup))
        (test t (< (length sup)
                   (length unsup)))
        ;(dolist  (one  unsup) (format t "~%unsup  ~a " one))
        ;(terpri)
        ;(dolist  (one  sup) (format t "~%  sup ~a "  one))
        ))))
