(defstruct result  target (a 0) (b 0) (c 0) (d 0) acc pf prec pd f g)

(defmethod print-object ((r result) str)
  (with-slots (target pf prec pd f g n c d acc) r
      (format str "target: ~a n: ~a pf: ~a prec: ~a pd: ~a f: ~a g: ~a acc: ~a"
	      target (+ c d) (round (* 100 pf)) (round (* 100 prec))
	      (round (* 100 pd)) (round (* 100 f))
	      (round (* 100 g))
	      (round (* 100 acc)))))

(defun results-show (results &optional (str t))
	(doh (klass result results)
		(print klass)
		(print result)))

(defun result! (result)
"Update all fields in one result"
  (with-slots ( a b c d acc pf prec pd f g n) result
    (let (notpf 
					(zip (/ 1 most-positive-fixnum)))
      (setf acc   (/ (+ a d)        (+ zip a b c d))
            pf    (/ c              (+ zip a c    ))
            prec  (/ d              (+ zip c d    ))
            pd    (/ d              (+ zip b d    ))
	    	    notpf (- 1 pf)
            f     (/ (* 2 prec pd)  (+ zip prec pd))
	          g     (/ (* 2 notpf pd) (+ zip notpf pd)))))
  result)

(defun results! (results)
  "Update all fields in a hash of results"
  (loop for result  being the hash-value of results do
    (result! result))
  results)

(defun results0 (klasses)
 "For each class in a table, generate one place to store results"
 (let ((results (make-hash-table)))
   (dolist (klass klasses results)
     (setf (gethash klass results)
           (make-result :target klass)))))

(defun whatif (results actual)
	"Whatif we assume we are predicting for each class?"
	(doh (predicted result results results)
		(results+ results actual predicted)))

(defun results+ (results actual predicted)
  (doh (target result results results)
       (with-slots (a b c d) result
         (if (eql actual target)
           (if (eql predicted actual)
             (incf d)
             (incf b))
           (if (eql predicted target)
             (incf c)
             (incf  a))))))
