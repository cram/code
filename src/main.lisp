(defun main ()
  (labels ((argv ()
             #+clisp ext:*args*
             #+sbcl sb-ext:*posix-argv*
             #+allegro (sys:command-line-arguments))
           (bye ()
             #+sbcl (sb-ext:exit)
             #+clisp (ext:exit)
             #+allegro (excl:exit)))
    (let* ((cmd  (cdr (argv)))
           (com  (and cmd (mapcar 'read-from-string cmd)))
           (fn   (and com (car com)))
           (args (and com (cdr com))))
      (if fn
          (apply fn args)
          (tests))
      (bye))))
