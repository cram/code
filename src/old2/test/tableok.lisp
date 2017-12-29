(in-package :cram)
(uses "../src/table")

(deftest defcol1! ()
  "let there be table, now"
  (let ((tb (make-instance 'table)))
    (defcol tb 'a 1)))
  
(deftest  defcol2! ()
  "losts of tests"
  (let ((tb (table0 'weather
                    '((aa    $bb $cc dd !ee)
                      (sunny 85 85 FALSE no)
                      (sunny 80 90 TRUE no)
                      (overcast 83 86 FALSE yes)
                      (rainy 70 96 FALSE yes)
                      (rainy 68 80 FALSE yes)
                      (rainy 65 70 TRUE no)
                      (overcast 64 65 TRUE yes)
                      (sunny 72 95 FALSE no)
                      (sunny 69 70 FALSE yes)
                      (rainy 75 80 FALSE yes)
                      (sunny 75 70 TRUE yes)
                      (overcast 72 90 TRUE yes)
                      (overcast 81 75 FALSE yes)
                      (rainy 71 91 TRUE no)))))
    
    (let* ((syms  (? tb x syms))
           (aa    (first syms))
           (dd    (second  syms))
           (nums (? tb x nums))
           (bb    (first nums))
           (cc    (second nums)))
      (test (? bb sd) 6.5716677)
      (test (? cc n) 14)
      (test (? cc sd) 10.285218)
      (test (ent aa) 1.5774063)
      (test (ent dd) 0.9852282)
    (print tb)
    )))

    
   
        

