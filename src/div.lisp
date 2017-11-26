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

;; (defun range-sum (arr &key (klass 'num) (f #'identity)
;;                         (lo 0) (hi (length arr)))
;;   (let ((out (make-instance klass)))
;;     (loop for i from lo to (1- hi) do
;;          (let ((lst (aref arr i)))
;;            (dolist (item lst)
;;              (add out (funcall f item)))))
;;     out))

(defun range-memo (arr fn &optional
                            (here 0)
                            (stop (1- (length arr)))
                            (memo (make-hash-table)))
  (let* ((inc  (if (> stop here) 1 -1))
         (now  (if (eql here stop)
                   (make-instance 'num)
                   (copy (range-memo arr fn (+ here inc) stop memo)))))
     (setf (gethash here memo)
           (dolist (item (aref arr here) now)  
             (add now (funcall fn item))))))
                                           
; XXX cache the ranges
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(Defun superranges1 (arr fn epsilon &aux out)
  "split array at point that minimized expected value of sd"
  (labels
      ((argmin (lo hi)
         (when (< lo hi)
           (let (cut
                 (best   most-positive-fixnum)
                 (lefts  (make-hash-table))
                 (rights (make-hash-table)))
             (print `(argmin ,lo ,hi))
             (range-memo arr fn (1- hi)  lo  lefts)
             (range-memo arr fn lo   (1- hi) rights)
             (loop for var being the hash-keys in lefts do
                (print `(loo ,var ,(gethash var lefts))))
             (let ((b4 (gethash 0 rights)))
               (loop for j from (1+ lo) to hi do
                    (print `(j ,j))
                    (let* ((l   (gethash (- j 1) lefts)) ;XXXX?
                           (r   (gethash (- j 1) rights)) ; XXXX?
                           (now (+ (xpect l (? b4 n))
                                   (xpect r (? b4 n)))))
                      (if (and (< now best)
                               (> (- (? r mu) (? l mu))
                                  epsilon))
                          (setf best now
                                cut  j)))))
             cut)))
       (recurse (lo cut hi)
         (split lo  cut)
         (split cut hi))   
       (split (lo hi)
         (let ((cut (argmin lo hi)))
           (if cut 
               (recurse lo cut hi)
               (push (a->l arr :lo lo :hi hi) out)))))
    (split 0 (length arr))
    out))

(defun bins (lst)
  (if (< (/ (length lst) 16))
      (/ (length lst) 10)
      (/ (length lst) 16)))

(defun superranges (lst &key (n        (bins lst))
                             (xepsilon 1)
                             (cohen    0.2)
                             (x        #'first)
                             (y        #'second))
  "Consider combining the splits found 'ranges' if the y-values
   in adjacent splits are too similar. Returns an array of array of numbers"
  (let* ((unsup (ranges lst :n 25 :epsilon xepsilon :f x))
         (arr   (l->a unsup))
         (nums  (range-memo arr y))
         (sup   (superranges1 arr y (* cohen (? nums sd))))
         )
    (print (? nums sd))
    (print (float (? nums mu)))
;    (values (reverse sup) unsup)
    ))
  
