
(defmacro o (&rest l)
  "Print a list of symbols and their bindings."
  (let ((last (gensym)))
    `(let (,last)
       ,@(mapcar #'(lambda(x) `(setf ,last (oprim ,x))) l)
       (terpri)
       ,last)))

(defmacro oprim (x)
  "Print a thing and its binding, then return thing."
  `(progn (format t "~&[~a]=[~a] " ',x ,x) ,x))

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

(defmacro doh ((k v h &optional out) &body body )
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

(defmacro until (test &body body)
  `(while (not ,test)
     ,@body))

(defun  let!prim  (s1 ss body)
  (let* ((x1 (if (listp s1) (first  s1) s1))
         (x2 (if (listp s1) (second s1)))
         (x3 (if (listp s1) (third  s1)))
         (y  (if ss
                 (list (let!prim (car ss) (cdr  ss) body))
                 body)))                  
    (cond 
      ((consp x1) `(multiple-value-bind ,x1 ,x2 ,@y))
      (x3         `(labels ((,x1 ,x2 ,x3))      ,@y))
      (t          `(let    ((,x1 ,x2))          ,@y)))))
 
(defmacro let! (specs &body body)
  "combines into one form
   let, multivalue-bind and  labels"
  (let!prim (car specs) (cdr specs) body))

(defun defslot  (slot x form)
  `(,slot
    :initarg  ,(intern (symbol-name slot) "KEYWORD")
    :initform ,form
    :accessor ,(intern (format nil "~a-~a" x slot))))

(defclass thing () ())

(defmacro defthing (x parent &rest slots)
  `(defclass ,x (,parent)
     ,(loop for (slot form) in slots collect (defslot slot x form))))

(defmacro ? (obj first-slot &rest more-slots)
  "From https://goo.gl/dqnmvH.
   Use case 2: access path known at load time.
   In this case, pre-compute the access path as a macro."
  (if (null more-slots)
      `(slot-value ,obj ',first-slot)
      `(? (slot-value ,obj ',first-slot) ,@more-slots)))
