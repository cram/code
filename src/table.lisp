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
  
(defconstant +less+  #\<)
(defconstant +more+  #\>)
(defconstant +num+   #\$)
(defconstant +klass+ #\!)
(defconstant +goal+  (list +less+ +more+ +klass+))

(defun defcol (tbl name pos)
  (labels
      ((num (slots) (doit 'num slots))
       (sym (slots) (doit 'sym slots))
       (doit (klass list-of-slots)
         (let ((col (make-instance klass)))
           (dolist (slots list-of-slots col)
             (change #'(lambda (slot) (tail-append slot col))
                     tbl slots)))))
    (case
        (char (symbol-name name) 0)
      (+more+  (num '((xy all) (xy nums) (y all) (y nums) (more)   )))
      (+less+  (num '((xy all) (xy nums) (y all) (y nums) (less)   )))
      (+num+   (num '((xy all) (xy nums) (x all) (x nums)          )))
      (+klass+ (sym '((xy all) (xy syms) (y all) (y syms) (klasses))))
      (t       (sym '((xy all) (xy syms) (x all) (x syms)       ))))))

(defun hasgoal (spec)
  (and spec
       (or (member   (char (symbol-name (car spec)) 0)
                     +goal+)
           (hasgoal  (cdr spec)))))

;xxx handle nump

(defun makegoal (row1 rows)
  (let* ((row1   (reverse row1))
         (col0   (pop row1))
         (datum  (car (last (first rows))))
         (what   (if (symbolp datum)
                    +klass+
                    +less+))
         (nump   (eql +num+
                      (char (symbol-name datum) 0)))
         (col    (intern 
                  (format nil "~a~a" what col0))))
    (cons (reverse (cons col row1))
          rows)))

(defun table0 (name rows)
  (let ((tb (make-instance 'table))
        (row1 (pop  rows)))
    (cond ((not (hasgoal row1))
           (table0 name (makegoal row1 rows)))
          (t
           (setf (? tb name) name
                 (? tb spec) row1)
           (doitems (txt pos row1  tb)
               (defcol tb txt pos))
           (adds tb rows)
           tb))))

(defun data (&key name columns egs)
  "handles a conversion from an older format"
  (table name (cons columns egs)))
