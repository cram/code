(load     "../src/boot")
(reload "../src/sample")

(deftest sample! ()
  (reset-seed)
  (let ((x (sample0 20)))
    (loop for i from 1 to 10 do (add x (randi 100)))
    (print (? x all))
    (print (sorted-contents x))
    (print (? x all))
    (print (contents x))
    (test 1 1)))


