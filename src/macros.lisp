
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

