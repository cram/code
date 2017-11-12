(load "../src/boot")


;;;; strings
(defun nchars (&optional (n 40) (c #\Space))
  (with-output-to-string (s)
    (dotimes (i n)
      (format s "~a" c))))

;;;; macros
(defmacro doitems ((one n list &optional out) &body body )
  "Set 'one' and 'n' to each item in a list, and its position."
  `(let ((,n -1))
     (dolist (,one ,list ,out)
       (incf ,n)
       ,@body)))

(defmacro while (test &body body)
  `(do ()
       ((not ,test))
     ,@body))

;;;;
(defmacro xslots (obj &rest names)
  `(mapcar #'(lambda (name) (cons name (slot-value ,obj name))) ',names))

(defmacro copier (old new &rest fields)
  `(with-slots ,fields ,old
     ,@(mapcar #'(lambda (slot)
                        `(setf (slot-value ,new ',slot) ,slot))
               fields)
     ,new))
;;;; maths
(defun round-to (number precision &optional (what #'round))
    (let ((div (expt 10 precision)))
      (float (/ (funcall what (* number div)) div))))

(defun r2 (n) (round-to n 2))

(defun r0 (n) (round-to n 0))

;;;; conversion
(defun l->a (lst)
  (make-array (length lst) :initial-contents lst))
   
;;;; Simple access/update to recursive slots in LISP
;; Tested on defstructs. Should also work on instances.
;; Tim@menzies.us, Oct 2017 
;; Builds on some excellent code from "Barmar", https://goo.gl/SQtNHd
(defun change (f obj slots)
  "Use case 1: access path for slots not known till runtime.
   In this case, pass in a function 'f' that will be used to
   update the slot found after travesing all the slots."
  (if (cdr slots)
      (change f (slot-value obj (car slots)) (cdr slots))
      (setf (slot-value obj (car slots))
            (funcall f (slot-value obj (car slots))))))

(defmacro with-place ((slot obj &rest slots) &rest body)
  `(change #'(lambda (,slot) ,@body)
            ,obj ',slots))

(defmacro ? (obj first-slot &rest more-slots)
  "From https://goo.gl/dqnmvH.
   Use case 2: access path known at load time.
   In this case, pre-compute the access path as a macro."
  (if (null more-slots)
      `(slot-value ,obj ',first-slot)
      `(? (slot-value ,obj ',first-slot) ,@more-slots)))


(defun defslot  (name form)
  `(,name
    :initarg  ,(intern (symbol-name name) "KEYWORD")
    :initform ,form
    :accessor ,name))

(defclass thing () ())

(defmacro defthing (x parent &rest slots)
  `(defclass ,x (,parent)
     ,(loop for (x form) in slots collect (defslot x form))))


(let* ((seed0      10013)
       (seed       seed0)
       (multiplier 16807.0d0)
       (modulus    2147483647.0d0))
  (defun reset-seed (&optional (n seed0))  (setf seed n))
  (defun randf      (&optional (n 1)) (* n (- 1.0d0 (park-miller-randomizer))))
  (defun randi      (&optional (n 1)) (floor (* n (/ (randf 1000.0) 1000))))
  (defun park-miller-randomizer ()
    "cycle= 2,147,483,646 numbers"
    (setf seed (mod (* multiplier seed) modulus))
    (/ seed modulus))
)

