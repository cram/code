; 
; <a href="http://doi.org/10.5281/zenodo.1054269"><img src=https://zenodo.org/badge/DOI/10.5281/zenodo.1054269.svg></a>
;
; One of my more effective tricks for teaching data mining (to graduate students) is to:
;
; 1. Give them a reference system in a language they do not know, 
; 2. Then make them port that code to a language that they do (e.g. Python).
;
; By the time that is done:
;
; - Students have a deep understanding of the core principles invloved;
; - Students know many of engineering decisions that might need adjusting when the code is used for real application;
; - Students have the skills required to make, and implement, those decisions.
;
; So here is my reference system for my standard data mining toolkit, written in a language
; that it is **very** unlikely that they have ever used before.
;
; Share and enjoy.
;
; ## Installation
;
; - Install `sbcl`. Currently I'm using 1.4.2,
; - Download and unzip https://github.com/lispth/code/archive/master.zip;
;
; All the files are now in `src/` and `test/`. Most of the files in `src/X.lisp`
; have demo code or unit tests in `test/Xok.lisp`. So all files know 
; where to find its dependents (in either `../src` or `../test`).
;
; Edit the file in the root of the distro called `lithp`. Change the following
; two lines to include the right pathnames.
;
;      # begin config
;      Sbcl="/usr/local/bin/sbcl"
;      Test="$HOME/gits/lispth/code/test"
;      # end config here
;
; ## Writing New Code
;
; **Step1:** Write a file `src/xxx.lisp` file in `src/`. Ensire its first lines are  
;
;      (load "../src/lib") 
;
; **Step2:** Write a second file `tests/xxxok.lisp'. Ensure its first lines are
; 
;      (load "../src/lib")
;      (reload "../src/xxx")
;      
; **IMPORTANTL** Note the `reload` command: this loads a file, but only if it has not been used before.  
; So all your code should start with one `load` command then some `reload` commands. 
;
; **Step3:** Into `tests/xxxok.lisp`, add multiple `deftest` commands. These functions should have a
; a documentation string, then arbitrary LISP code. Any call `test` will iincrement
; counters of how many times those tests _pass_ or _fail_.
;
;    (deftest r2! ()
;       "does 'r1' round to 2 decimal places"
;       (test 0.13 (r2 0.127456)))
;
; **Step4:** Run the above. Create an `ok` file
; 
;     #!/bin/bash
;     ok () {
;         local here=$PWD;
;         cd $Here/test;
;         echo ";;;; ../test/${1}ok";
;         time $Sbcl --noinform --disable-debugger --eval "
;                       (progn (reload \"../test/${1}ok\")
;                              (tests) 
;                             (exit))"
;         cd $here
;     }
;     ok $1
;
;
; ## Structure
;
; There are two parts, _background tools_ and _core_
;
; ### Background
;
; Defined in `boot.lisp`

(defun relad (file)
  "Load file.lisp it it has not been loaded before")

(defun def
;


(general
  (boot  ; start up routines. 
    (does 
      deftest
      test
      tests
      )
(table ; table.lisp
   (has (rows cols
