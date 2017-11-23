(in-package :cram)
(needs "../src/sym")

(deftest sym! ()
  "Sampling from some syms"
  (reset-seed)
  (let* ((p  (sym* '(1 1 1 1 2 2 3 )))
         (q  (sym* (loop for i from 1 to 7000
                      collect (any p)))))
    (dohash (k v (? q cnt))
      (print `(k ,k v ,v)))))
    
(deftest ent! ()
  "calc entropy"
  (let ((s (sym* '(a b b c c c c))))
    (test 1.3788 (r4 (ent s)))))
