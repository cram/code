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
  (labels ((prep (n)
             (list n (cond ((< n 20) (randi 5))
                           ((< n 80) (+ 10 (randi 5)))
                           (t        (+ 100 (randi 5)))))))
    (let* ((lst  (loop for i from 1 to 100 collect (prep (randi 100))))
           
          ; (l5   (superranges lst :n  10))
           ;(l3   (superranges lst :n  3))
           )
      ;(print `(l5 ,l5))
                                        ;(print `(l3 ,l3))
      (print lst)
      (superranges lst)
                           ;         (print (superranges lst :n 7))
      )))
