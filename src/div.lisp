(in-package :cram)
(uses "../src/lib"
      "../src/num")

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro with-ranges ((one arr &key (f #'identity) (lo 0) hi out) &body body)
  (let ((i     (gensym))
        (two   (gensym))
        (three (gensym)))
    `(progn
       (loop for ,i from ,lo to (or ,hi (1- (length ,arr))) do
            (let ((,three (aref ,arr ,i)))
              (dolist (,two ,three)
                (let ((,one (funcall ,f ,two)))    
                  ,@body))))
       ,out)))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun superranges1 (arr what epsilon &aux out)
  "split array at point that minimized expected value of sd"
  (labels
      ((all (lo hi &aux (out (make-instance 'num )))
         (with-ranges (one arr :f  what :out out :lo lo :hi (1- hi))
           (add out one)))
       (argmin (lo hi &aux cut (best most-positive-fixnum))
         (if (< lo hi)
             (let ((b4 (all lo hi)))
               (loop for j from lo to (1- hi) do
                    (let* ((l   (all 0      j))
                           (r   (all (1+ j) hi))
                           (now (+ (xpect l (? b4 n))
                                   (xpect r (? b4 n)))))
                      (if (< now best)
                          (if (> (- (? r mu) (? l mu))
                                 epsilon)
                              (setf best now
                                    cut  j)))))))
         cut)
       (recurse (lo cut hi)
         (print `(cut ,lo ,cut ,hi))
         (split lo       cut)
         (split (1+ cut)   hi))
       (split (lo hi)
         (aif (argmin lo hi) 
              (recurse lo it hi)
              (push (a->l arr :lo lo :hi hi) out))))
    (split 0 (length arr))
    out))

(defun superranges (lst &key (n 20) (xepsilon 0) (cohen 0.2)
                          (x #'first) (y #'second))
  "Split x-values in ranges; combine ranges that do not alter y.
   Returns an array of array of numbers"
  (let* ((arr      (l->a
                    (ranges lst :n n :epsilon xepsilon :f x)))
         (n        (make-instance 'num)) ; XXX need two levesl of add here
        (yepsilon  (* cohen
                      (with-ranges (yval arr :f y :out (? n sd))
                        (add n yval))))
         )
    (print yepsilon)
;    (print yepsilon)
    (print (superranges1 arr y yepsilon))
    ))

