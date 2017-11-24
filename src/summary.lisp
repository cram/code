(in-package :cram)

(uses "../src/lib")

(defthing summary thing
  (txt "") (pos 0) (n 0) (w 1))
 
(defmethod add1((x summary) y)
  (declare (ignore x y))
  (assert nil () "add1 should be implemented by subclass"))

(defmethod norm1((x summary) y)
  (declare (ignore x y))
  (assert nil () "norm1 should be implemented by subclass"))

(defmethod add ((x summary) y &optional (f #'identity))
  (print `(addsyn y ,y  f ,f y1 ,(funcall f y) raw ,(second y)))
  (let ((y1 (funcall f y)))
    (print `(add-summary ,y y1 ,y1))
    (with-slots (n) x
      (when (not (eql y1 #\?))
        (incf n)
        (add1 x y1 ))
      y)))

(defmethod adds ((x summary) ys  &optional (f #'identity))
  (print `(adds ,ys))
  (dolist (y ys x)
    (add x y f)))

(defmethod xadds ((x summary) (ys simple-vector) &optional (f #'identity))
  (loop for y across ys do 
        (add x y f)))
  
(defmethod norm ((x summary) y)
  (if (eql y #\?) y (norm1 x y)))
