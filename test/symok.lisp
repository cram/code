(load "../src/boot")
(reload "../src/sym")


    
(deftest sym! ()
  "Sampling from some syms"
  (let ((s (sym* '(1 1 1 2))))
    (print
     (sort
      (loop for i from 1 to 100 collect (any s))
      #'<))))

(deftest ent! ()
  "calc entropy"
  (let ((s (sym* '(a b b c c c c))))
    (test 1.3788 (r4 (ent s)))))
