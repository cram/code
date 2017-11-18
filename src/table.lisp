(load   "../src/boot")
(reload "../src/lib")
(reload "../src/num")
(reload "../src/sym")
(reload "../src/sample")

;## Col
;
; Keep stats on a column, plus a small `sample` of
; any of the numbers.

(defthing col thing
  (has)
  (any  (make-instance 'sample)))

(defmethod print-object ((x col) src)
  (format src "~a" `(col  ,(slots x has any))))

(defmethod adds ((x col) y  &optional (f #'identity))
  (let ((y (funcall f y)))
    (adds (? x has) y)
    (adds (? x any) y)))

(defmethod add ((x col) y &optional (f #'identity))
  (let ((y (funcall f y)))
    (add (? x has) y)
    (add (? x any) y)))

;-----
;## Cols
;
; `Cols` are sets of `col`s which can be
; `nums` or `syms` (and both of them as stored
; in `all`.

(defthing cols thing
  (all) (nums) (syms))

(defmethod print-object ((obj cols) src)
  (let ((details (slots obj all nums syms)))
    (format src "~a" `(cols ,details))))

;## Table
;
; `Table`s have `rows` which are summarizes
; in different sets of `cols`. Depedent variables
; are stored in `x`; independent variabkes areare sets of `col`s which can be
; `nums` or `syms` (and both of them as stored
; in `all`.

(defthing table thing
  (name)    
  (rows) 
  (spec)
  (klasses) (less) (more)
  (xy (make-instance 'cols))
  (x  (make-instance 'cols))
  (y  (make-instance 'cols)))

(defmethod add ((tb table) (row cons) &optional filter)
  (declare  (ignore filter))
  (push (mapcar  #'add  (? tb xy all) row)
        (? tb rows)))

(defmethod adds ((tb table) rows &optional filter)
  (declare (ignore filter))
  (mapcar #'(lambda (row) (add tb row)) rows))

(defmethod print-object ((obj table) src)
  (let ((details (slots obj klasses less more xy x y)))
    (format src "~a" `(table ,details))))
  
(defun defcol (tbl name pos)
  (labels
      ((summ (s) (make-instance 'col :has s))
       (num  ()  (summ (make-instance 'num :txt  name :pos pos)))
       (sym  ()  (summ (make-instance 'sym :txt  name :pos pos)))
       (doit (col list-of-slots)
         (dolist (slots list-of-slots col)
           (change #'(lambda (slot) (cons col slot))
                   tbl slots))))
    (case
        (char (symbol-name name) 0)
      (#\> (doit (num) '((xy all) (xy nums) (y all) (y nums) (more)   )))
      (#\< (doit (num) '((xy all) (xy nums) (y all) (y nums) (less)   )))
      (#\$ (doit (num) '((xy all) (xy nums) (x all) (x nums)          )))
      (#\! (doit (sym) '((xy all) (xy syms) (y all) (y syms) (klasses))))
      (t   (doit (sym) '((xy all) (xy syms) (x all) (x syms)       ))))))

(defun table0 (name spec)
  (let ((tb (make-instance 'table)))
    (setf (? tb name) name
          (? tb spec) spec)
    (doitems (txt pos spec tb)
        (defcol tb txt pos))))
