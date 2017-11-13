(load "../src/boot")
(reload "../src/lib")
(reload "../src/num")

;;;;;;;;;;;;;;;;;
(defun ranges1 (lst &key  (n 20) (epsilon 1) (f #'identity))
  (let ((tmp)
        (first   (car lst))
        (counter n))
    (while (and lst (>= (decf counter) 0))
      (push (pop lst) tmp))
    (while (and lst
                (let ((first    (funcall f first))
                      (current  (funcall f (car tmp)))
                      (next     (funcall f (car lst))))
                  (or
                   (< (- current first) epsilon)
                   (eql current next))))
      (push (pop lst) tmp))
    (cond ((< (length lst) n)  (while lst
                                 (push (pop lst) tmp))
                               (list tmp))
          (t (cons tmp
                   (ranges1 lst :n n :epsilon epsilon :f f))))))

(defun ranges (lst &key  (n 20) (epsilon 1) (f #'identity))
  (ranges1
   (sort lst #'(lambda (a b)  (< (funcall f a) (funcall f b))))
   :n n :epsilon epsilon :f f))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun superranges1 (arr f e &aux out)
  "split array at point that minimized expected value of sd"
  (macrolet ((at (n v) `(slot-value (aref arr ,n) ,v)))
    (labels
        ((sd  (b4 z)
           (* (at z 'sd)
              (/ (at z 'n) (at b4 'z))))                        
         (all (lo hi &aux (out (make-instance 'num)))
             (loop for j from lo to hi do
                  (adds out (aref arr j) f)
                return out))
         (argmin (lo hi &aux cut (best most-positive-fixnum))
           (if (< lo hi)
               (let ((b4 (all lo hi)))
                 (loop for j from lo to (1- hi) do
                      (let* ((l   (all 0      j))
                             (r   (all (1+ j) hi))
                             (now (+ (sd b4 l) (sd b4 r))))
                        (if (< now best)
                            (if (> (- (at r 'mu) (at l 'mu)) e)
                                (setf best now
                                      cut  j)))))))
           cut)
         (recurse (lo cut hi)
           (split lo        cut)
           (split (1+ cut)  hi))
         (split (lo hi)
           (aif (argmin lo hi) 
                (recurse lo it hi)
                (push (a->l arr :lo lo :hi hi) out)))
      (split 0 (1- (length arr)))
      out)))

(defun superranges (lst &key (n 20) (xepsilon 0) (cohen 0.2)
                          (x #'first) (y #'second))
  "Split x-values in ranges; combine ranges that do not alter y.
   Returns an array of array of numbers"
  (let* ((arr      (l->a
                    (ranges lst :n n :epsilon xepsilon :f x)))
         (yepsilon (* cohen
                      (slot-value (num* lst y) 'sd))))
    (superranges1 arr y yepsilon)))

