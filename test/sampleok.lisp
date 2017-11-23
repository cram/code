(in-package :cram)

(needs "../src/boot"
       "../src/sample")

(deftest sample! ()
  (reset-seed)
  (let ((x (make-instance 'sample :most 20)))
    (loop for i from 1 to 10 do (add x (randi 100)))
    (print (? x all))
    (print (sorted-contents x))
    (print (? x all))
    (print (contents x))
    (test 1 1)))

(deftest tiles! ()
  (reset-seed)
  (let ((x (make-instance 'sample :most 200)))
    (loop for i from 1 to 10000 do (add x i))
    (print (tiles x))))  
