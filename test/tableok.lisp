(load   "../src/boot")
(reload "../src/table")

(deftest defcol1! ()
  "let there be table"
  (let ((tb (make-instance 'cols))) tb))
  
(deftest defcol2! ()
  (let* ((tb   (make-instance 'table))
         (eg  `((aa    $bb $cc dd !ee)
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
                (rainy 71 91 TRUE no)))
         (cols  (car eg)))
    (doitems (z pos cols tb)
      (defcol tb z pos))))

    
   
        
