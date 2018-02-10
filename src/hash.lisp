(defun hash-keys (h)
    (loop for key being the hash-keys of h
          collect key))


(defun nestedHash (keys hash)
  (dolist (key keys hash)
    (let ((tmp (gethash hash key)))
      (unless tmp
        (setf tmp (make-hash-table))
        (setf (gethash hash key) tmp))
      (setf hash tmp))))

