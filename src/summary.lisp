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
  (with-slots (n) x
    (when (not (eql y #\?))
      (incf n)
      (add1 (funcall f x) y ))
    y))

(defmethod adds ((x summary) (ys cons) &optional (f #'identity))
  (dolist (y ys x)
    (add x y f)))

(defmethod adds ((x summary) (ys simple-vector) &optional (f #'identity))
  (loop for y across ys do 
        (add x y f)))
  
(defmethod norm ((x summary) y)
  (if (eql y #\?) y (norm1 x y)))
