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
  (mapcar
   #'reverse
   (ranges1
    (sort lst #'(lambda (a b)  (< (funcall f a) (funcall f b))))
    :n n :epsilon epsilon :f f)))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro with-array-list-items
    ((one arr &key (f #'identity) (lo 0) hi out) &body body)
  "Iterate over the items in an array of list of items.
   Optionally, Items are filtered via a function 'f'.
   Consistent with subseq, this runs from lo to hi-1"
  (let ((i     (gensym))
        (two   (gensym))
        (three (gensym)))
    `(progn
       (loop for ,i from ,lo to (1- (or ,hi (length ,arr))) do
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
         (with-array-list-items
             (one arr :f what :out out :lo lo :hi hi)
           (add out one)))
       (argmin (lo hi &aux cut (best most-positive-fixnum))
         (when (< lo hi)
           (let ((b4 (all lo hi)))
             (loop for j from (1+ lo) to hi do
                  (let* ((l   (all lo j))
                         (r   (all j hi))
                         (now (+ (xpect l (? b4 n))
                                 (xpect r (? b4 n)))))
                    (if (< now best)
                        (if (> (- (? r mu) (? l mu))
                               epsilon)
                            (setf best now
                                  cut  j)))))))
         cut)
       (recurse (lo cut hi)
         (split lo  cut)
         (split cut hi))
       (stop (lo hi)
         (push (a->l arr :lo lo :hi hi) out))       
       (split (lo hi)
         (let ((cut (argmin lo hi)))
           (if cut 
               (recurse lo cut hi)
               (stop lo hi)))))
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
                      (with-array-list-items
                          (yval arr :f y :out (? n sd))
                        (add n yval))))
         )
    (print yepsilon)
;    (print yepsilon)
    (print (first (superranges1 arr y yepsilon)))
    ))

