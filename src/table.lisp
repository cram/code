(in-package :cram)
(uses "../src/lib"
      "../src/num"
      "../src/sym"
      "../src/sample")


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

(defmethod add ((tb table) row  &optional (filter #'identity))
  (declare  (ignore filter))
  (push (mapcar  #'add  (? tb xy all) row)
        (? tb rows)))

(defmethod adds ((tb table) rows &optional filter)
  (declare (ignore filter))
  (mapcar #'(lambda (row) (add tb row)) rows))

(defmethod print-object ((obj table) src)
  (let ((details (slots obj klasses less more xy x y)))
    (format src "~a"
            (list 'table
                  `(rows ,(length (? obj rows)))
                  `(cols ,details)))))
  
(defun defcol (tbl name pos)
  (labels
      ((num () (make-instance 'num :txt  name :pos pos))
       (sym () (make-instance 'sym :txt  name :pos pos))
       (doit (col list-of-slots)
         (dolist (slots list-of-slots col)
           (change #'(lambda (slot) (tail-append slot col))
                   tbl slots))))
    (case
        (char (symbol-name name) 0)
      (#\> (doit (num) '((xy all) (xy nums) (y all) (y nums) (more)   )))
      (#\< (doit (num) '((xy all) (xy nums) (y all) (y nums) (less)   )))
      (#\$ (doit (num) '((xy all) (xy nums) (x all) (x nums)          )))
      (#\! (doit (sym) '((xy all) (xy syms) (y all) (y syms) (klasses))))
      (t   (doit (sym) '((xy all) (xy syms) (x all) (x syms)       ))))))

(defun table0 (name rows)
  (let ((tb (make-instance 'table))
        (row1 (pop  rows)))
    (setf (? tb name) name
          (? tb spec) row1)
    (doitems (txt pos row1  tb)
        (defcol tb txt pos))
    (adds tb rows)
    tb
    
    ))
