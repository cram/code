(load   "../src/boot")
(reload "../src/lib")
(reload "../src/num")
(reload "../src/sym")
(reload "../src/sample")

(defthing col thing
  (summary)
  (sample (make-instance 'sample)))

(defmethod adds ((x col) y  &optional (f #'identity))
  (let ((y (funcall f y)))
    (add (? x summary) y)
    (add (? x sample) y)))
    
(defthing cols thing
  (all) (nums) (syms))

(defthing table thing
  (klasses) (less) (more)
  (xy (make-instance 'cols))
  (x  (make-instance 'cols))
  (y  (make-instance 'cols)))

(defmethod print-object ((x table) src)
  (format src "~a" `(table ,(slots klasses less more xy x y))))
  
(defun defcol (tbl name pos)
  (labels
      ((summ (s) (make-instance 'col :summary s))
       (num  ()  (summ (make-instance 'num :txt  name :pos pos)))
       (sym  ()  (summ (make-instance 'sym :txt  name :pos pos)))
       (doit (col list-of-slots)
         (dolist (slots list-of-slots)
           (change #'(lambda (slot) (cons col slot))
                   tbl slots))))
    (case
        (char (symbol-name name) 0)
      (#\> (doit (num) '((xy all) (xy nums) (y all) (y nums) (more)   )))
      (#\< (doit (num) '((xy all) (xy nums) (y all) (y nums) (less)   )))
      (#\$ (doit (num) '((xy all) (xy nums) (x all) (x nums)          )))
      (#\! (doit (sym) '((xy all) (xy syms) (y all) (y syms) (klasses))))
      (t   (doit (sym) '((xy all) (xy syms) (x all) (x syms)       ))))))

(defun deftable1 (name cols rows)
  (let ((tb (make-instance 'tbl :txt  name :cols cols)))
    (doitems (col pos cols tb)
      (defcol tb col pos))))

;(defmacro deftable (name (&rest cols) &body rows)
 ; `(deftable1 ',name ',cols ',rows))
