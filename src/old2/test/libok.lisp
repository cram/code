(in-package :cram)

(uses "../src/lib")

(deftest chars! ()
  "seeking 3 characters"
  (test (nchars 3 #\;) ";;;"))

(deftest doitems! ()
    (let* ((out)
           (lst '(a b c d)))
      (test '((3 . D) (2 . C) (1 . B) (0 . A))
            (doitems (one n lst out)
                (push (cons n one) out)))))


(deftest while! ()
    (let* ((out)
           (lst '(a b c d)))
      (while lst
        (push (cons 'aa (pop lst)) out))
      (test '((aa . D) (aa . C) (aa . B) (aa . A))
            out)))

;;; Test code

;; "(make-xxxx)" creates a recursive set of structs.
(defstruct zzzz z1 (z2 0) (z3))
(defstruct yyyy y1 y2 (y3 (make-zzzz)))
(defstruct xxxx x1 x2 (x3 (make-yyyy)))

(defun xyz-demo ()
  (let ((tmp (make-xxxx)))
    (incf (? tmp  x3 y3 z2) 100)
    (dotimes (i 5)
      (push (+ 100 (* 100 i))  (? tmp x3 y3 z3)))
    (with-place (slot tmp x3 y3 z2)
      (+ 21 slot))
    (with-place (slot tmp x3 y3 z3)
      (cons 5555 slot))
    (test '(5555 500 400 300 200 100) (? tmp x3 y3 z3))
    (test 121 (? tmp x3 y3 z2))))

(deftest r2! ()
    (test 0.13 (r2 0.127456)))

(defthing athing thing (a 1) (b 2))

(deftest athing! ()
    (let ((x (make-instance 'athing)))
      (setf (? x a) 2000)
      (test 2000 (? x a))))

(deftest randi1! ()
  (reset-seed)
  (print
   (sort
    (loop for i from 1 to 100
       collect  (randi 10)) #'<))
  )

(deftest randf! ()
  (let (one two)
    (reset-seed)
    (setf one (round-to (randf) 5))
    (reset-seed)
    (setf two  (round-to (randf) 5))
    (test one two)))

(deftest testlet ()
  (let* ((a 10)
         (b 20))
    (let! ((f1 (x) (values `(f11 ,x) 999))
           (c 30)
           (d a)
           (e (* d 10))
           ((f g) (f1 (* e 10)))
           )
      (print `(a ,a b ,b c ,c d ,d e ,e f ,f g ,g))
      (print (if (eql a 10) t nil))
      (test a 10)
      (test b 20)
      (test c 30)
      (test d 10)
      (test e 100)
      (print  10000)
      (test f `(f11 1000))
      (test g 999))))  
