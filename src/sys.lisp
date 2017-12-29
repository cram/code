(defun argv ()
  #+clisp ext:*args*
  #+sbcl sb-ext:*posix-argv*
  #+allegro (sys:command-line-arguments))

(defun bye ()
  #+sbcl (sb-ext:exit)
  #+clisp (ext:exit)
  #+allegro (excl:exit))

(defun quiet-load (mode &rest files)
  (if mode
      #+sbcl
      

