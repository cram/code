(in-package :cram)

; ## String Tricks
;
(defun nchars (&optional (n 40) (c #\Space))
  (with-output-to-string (s)
    (dotimes (i n)
      (format s "~a" c))))

(defun dot (&optional (c "."))
  (princ c) 
  (finish-output))

; -----------------
; ## List tricks
;
(defun select (selector-fn facts)
  "return all list items satisying selector-fn"
  (remove-if-not selector-fn facts))

(defun visit (fn l)
  "apply fn to all items in nested lists"
  (if (atom l)
      (funcall fn l)
      (dolist (one l)
  (visit fn one))))

(defun flatten (l)
  (let (out)
    (visit #'(lambda (one) (push one out)) l)
    (reverse out)))

(defun tail-append (lst x)
  (append lst (list x)))

; ------------------------
; ## Macro Tricks
;
(defmacro aif (test then &optional else)
  "Anaphoric 'if'"
  `(let ((it ,test))
     (if it ,then ,else)))

(defmacro doitems ((one n list &optional out) &body body )
  "Set 'one' and 'n' to each item in a list, and its position."
  `(let ((,n -1))
     (dolist (,one ,list ,out)
       (incf ,n)
       ,@body)))

(defmacro dohash ((k v h &optional out) &body body )
  "Set key 'k' and value 'v' to each item in a list, and its position."
  `(progn
     (maphash #'(lambda (,k ,v)
                  ,@body)
              ,h)
     ,out))

(defmacro while (test &body body)
  `(do ()
       ((not ,test))
     ,@body))

;----------------
; ## Maths Tricks
;
(defun round-to (number precision &optional (what #'round))
    (let ((div (expt 10 precision)))
      (float (/ (funcall what (* number div)) div))))

(defun r4 (n) (round-to n 4))
(defun r2 (n) (round-to n 2))
(defun r0 (n) (round-to n 0))

; ----
; ## Coercion
;
(defun l->a (lst)
  (make-array (length lst) :initial-contents lst))

(defun a->l (a &key (lo 0) (hi (length a)))
  (coerce (subseq a lo hi) 'list))

(labels
    ((s->x (str &optional (reader #'read-char))
       (if (not (streamp str))
           (s->x (make-string-input-stream str) reader)
           (if (listen str)
               (cons (funcall reader str)
                     (s->x    str reader))))))
  (defun s->w (str) (s->x str  #'read))
  (defun s->l (str) (s->x str  #'read-char)))

; ----
; ## Defstruct Tricks
;
(defmacro slots (obj &rest names)
  `(mapcar #'(lambda (name) (cons name (slot-value ,obj name))) ',names))

(defmacro copier (old new &rest fields)
  `(with-slots ,fields ,old
     ,@(mapcar #'(lambda (slot)
                        `(setf (slot-value ,new ',slot) ,slot))
               fields)
     ,new))

; -----------------------------
; ## Class Slot Accessor Tricks
;
; Simple access/update to recursive slots in LISP.
; Builds on some excellent code from "Barmar", https://goo.gl/SQtNHd

(defun change (f obj slots)
  "Use case 1: access path for slots not known till runtime.
   In this case, pass in a function 'f' that will be used to
   update the slot found after travesing all the slots."
  (if (cdr slots)
      (change f (slot-value obj (car slots)) (cdr slots))
      (setf (slot-value obj (car slots))
            (funcall f (slot-value obj (car slots))))))

(defmacro ? (obj first-slot &rest more-slots)
  "From https://goo.gl/dqnmvH.
   Use case 2: access path known at load time.
   In this case, pre-compute the access path as a macro."
  (if (null more-slots)
      `(slot-value ,obj ',first-slot)
      `(? (slot-value ,obj ',first-slot) ,@more-slots)))

(defmacro with-place ((slot obj &rest slots) &rest body)
  `(change #'(lambda (,slot) ,@body)
            ,obj ',slots))

; -----------------
; ## Creation Tricks

(defun defslot  (name form)
  `(,name
    :initarg  ,(intern (symbol-name name) "KEYWORD")
    :initform ,form
    :accessor ,name))

(defclass thing () ())

(defmacro defthing (x parent &rest slots)
  `(defclass ,x (,parent)
     ,(loop for (x form) in slots collect (defslot x form))))

; ------------------------------------
; ## Portable Random Number Generator
;

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

(defun my-getenv (name &optional default)
    #+CMU
    (let ((x (assoc name ext:*environment-list*
                    :test #'string=)))
      (if x (cdr x) default))
    #-CMU
    (or
     #+Allegro (sys:getenv name)
     #+CLISP (ext:getenv name)
     #+ECL (si:getenv name)
     #+SBCL (sb-unix::posix-getenv name)
     #+LISPWORKS (lispworks:environment-variable name)
     default))

(print (my-getenv "RANDOM"))
