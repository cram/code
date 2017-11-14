(load   "../src/boot")
(reload "../src/lib")
(reload "../src/num")
(reload "../src/sym")
(reload "../src/sample")

(defthing col thing
  (summary)
  (sample))

(defthing cols thing
  (all) (nums) (syms))

(defthing table thing
  (xy (make-instance 'cols))
  (x  (make-instance 'cols))
  (y  (make-instance 'cols)))
  
(defun defcol (tbl name pos)
  (labels
      ((summ (s) (make-instance
                  :summary s
                  :sample  (make-instance 'sample)))
       (num  ()  (summ (make-instance 'num :name name :pos pos)))
       (sym  ()  (summ (make-instance 'sym :name name :pos pos)))
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
  (let ((tb (make-instance 'tbl :name name :cols cols)))
    (doitems (col pos cols tb)
      (defcol tb col pos))))

(defmacro deftable (name (&rest cols) &body rows)
  `(deftable1 ',name ',cols ',rows))
