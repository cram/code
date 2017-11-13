(load "../src/boot")
(reload "../src/sym")

(deftest sym! ()
  (let ((s (sym* '(1 1 1 1 2 2))))
    (print
     (sort
      (loop for i from 1 to 100 collect (any s))
      #'<))))
    
