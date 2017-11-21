

;## Welcome to CRAM
; 
; <a href="http://doi.org/10.5281/zenodo.1054269"><img src=https://zenodo.org/badge/DOI/10.5281/zenodo.1054269.svg></a>
;
; One of my more effective tricks for teaching data mining (to graduate students) is to:
;
; 1. Give them a reference system in a language they do not know, 
; 2. Then make them port that code to a language that they do (e.g. Python).
;
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
;## Installation
;
; The following instructions work for Mac. Probably work for LINUX as well.
;
; 1. Install `sbcl`. Currently I'm using 1.4.2,
; 2. Download and unzip https://github.com/cram/code/archive/master.zip;
;
; All the files are now in `src/` and `test/`. Most of the files in `src/X.lisp`
; have demo code or unit tests in `test/Xok.lisp`. 
;
; Edit the file in the root of the distro called `cram`. Change the following
; two lines to include the right pathnames.
;
;     ## begin config
;
;     # Where is sbcl?
;     Sbcl="/usr/local/bin/sbcl"
;     
;     # Where is the test dir?
;     Test="$HOME/gits/lisp/cram/code/test"
;     ## end config here
;
; Test the install
;
;     sh lithp
;
; This should generate lots of output and no crashes.
;
;## Writing New Code
;
; All these files know 
; that, to find  dependents, look  in either `../src` or `../test`. So,
; to write new files...
;
; **Step1:** Write a file `src/xxx.lisp` file in `src/`. Ensure its first lines are  
;
;      (load "../src/lib") 
;
; **Step2:** Write a second file `tests/xxxok.lisp'. Ensure its first lines are
; 
;      (load "../src/lib")
;      (reload "../src/xxx")
;      
; **IMPORTANT:** Note the `reload` command: this loads a file, but only if it has not been used before.  
; So all your code should start with one `load` command then some `reload` commands. 
;
; **Step3:** Into `tests/xxxok.lisp`, add multiple `deftest` commands. These functions should have a
; a documentation string, then arbitrary LISP code. Any call `test` will iincrement
; counters of how many times those tests _pass_ or _fail_.
;
;     (deftest r2! ()
;       "does 'r1' round to 2 decimal places"
;       (test 0.13 (r2 0.127456)))
;
; **Step4:** Run the above. Create an `ok` file
;
;     sh cram xxx
;
; That should run the `xxx` file.
;
;## Structure
;
;There are two parts, _background tools_ and _core_.
;
; here ehtere
;
;## Metaphor
;
;### asdadas
;
;asd asd asd asd asda sd asdas
; as asd asd asd asd asda sdas dasd asd asdasdd
; saasd as sadas das asdadsdaas 

