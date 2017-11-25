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

(defun range-sum (arr &key (klass 'num) (f #'identity)
                        (lo 0) (hi (length arr)))
  (let ((out (make-instance klass)))
    (loop for i from lo to (1- hi) do
         (let ((lst (aref arr i)))
           (dolist (item lst)
             (add out (funcall f item)))))
    out))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(Defun superranges1 (arr fn epsilon &aux out)
  "split array at point that minimized expected value of sd"
  (labels
      ((all (lo hi)
         (range-sum arr :lo lo :hi hi :f fn))
       (argmin (lo hi &aux cut (best most-positive-fixnum))
         (when (< lo hi)
           (let ((b4 (all lo hi)))
             (loop for j from (1+ lo) to hi do
                  (let* ((l   (all lo  j))
                         (r   (all j  hi))
                         (now (+ (xpect l (? b4 n))
                                 (xpect r (? b4 n)))))
                    (if (and (< now best)
                             (> (? r mu) (? l mu)
                                epsilon))
                            (setf best now
                                  cut  j))))))
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

(defun superranges (lst &key (n        (sqrt (length lst)))
                             (xepsilon 1)
                             (cohen    0.2)
                             (x        #'first)
                             (y        #'second))
  "Consider combining the splits found 'ranges' if the y-values
   in adjacent splits are too similar. Returns an array of array of numbers"
  (let* ((unsup (ranges lst :n n :epsilon xepsilon :f x))
         (arr   (l->a unsup))
         (nums  (range-sum arr :f y))
         (sup   (superranges1 arr y (* cohen (? nums sd)))))
    (values (reverse sup)
            unsup)))
  
