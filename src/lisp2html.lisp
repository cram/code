;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

(load "~/quicklisp/setup.lisp")
(asdf:load-system "markdown.cl")
(defpackage #:lisp2html (:use #:cl))
(in-package #:lisp2html)

(defconstant *banner*
  "http://files.vladstudio.com/joy/infinity_2_blue/wall/vladstudio_infinity_2_blue_600x150.jpg"
)
(defconstant *header*
"<html>
<head>
<title>~a</title>
<style>
~a
</style>
</head>
<body>
<div class=body>
<center>
<img src=\"~a\" width=790>
</center>

")

(defconstant *style*
"

/* latin-ext */
@font-face {
  font-family: 'Lato';
  font-style: normal;
  font-weight: 400;
  src: local('Lato Regular'), local('Lato-Regular'), url(http://fonts.gstatic.com/s/lato/v11/8qcEw_nrk_5HEcCpYdJu8BTbgVql8nDJpwnrE27mub0.woff2) format('woff2');
  unicode-range: U+0100-024F, U+1E00-1EFF, U+20A0-20AB, U+20AD-20CF, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Lato';
  font-style: normal;
  font-weight: 400;
  src: local('Lato Regular'), local('Lato-Regular'), url(http://fonts.gstatic.com/s/lato/v11/MDadn8DQ_3oT6kvnUq_2r_esZW2xOQ-xsNqO47m55DA.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2212, U+2215, U+E0FF, U+EFFD, U+F000;
}
/* latin-ext */
@font-face {
  font-family: 'Lato';
  font-style: normal;
  font-weight: 700;
  src: local('Lato Bold'), local('Lato-Bold'), url(http://fonts.gstatic.com/s/lato/v11/rZPI2gHXi8zxUjnybc2ZQFKPGs1ZzpMvnHX-7fPOuAc.woff2) format('woff2');
  unicode-range: U+0100-024F, U+1E00-1EFF, U+20A0-20AB, U+20AD-20CF, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Lato';
  font-style: normal;
  font-weight: 700;
  src: local('Lato Bold'), local('Lato-Bold'), url(http://fonts.gstatic.com/s/lato/v11/MgNNr5y1C_tIEuLEmicLmwLUuEpTyoUstqEm5AMlJo4.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2212, U+2215, U+E0FF, U+EFFD, U+F000;
}
/* latin-ext */
@font-face {
  font-family: 'Lato';
  font-style: normal;
  font-weight: 900;
  src: local('Lato Black'), local('Lato-Black'), url(http://fonts.gstatic.com/s/lato/v11/t85RP2zhSdDjt5PhsT_SnlKPGs1ZzpMvnHX-7fPOuAc.woff2) format('woff2');
  unicode-range: U+0100-024F, U+1E00-1EFF, U+20A0-20AB, U+20AD-20CF, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Lato';
  font-style: normal;
  font-weight: 900;
  src: local('Lato Black'), local('Lato-Black'), url(http://fonts.gstatic.com/s/lato/v11/lEjOv129Q3iN1tuqWOeRBgLUuEpTyoUstqEm5AMlJo4.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2212, U+2215, U+E0FF, U+EFFD, U+F000;
}
body {  font-size: small;
        font-family:Lato,sans-serif; 
        background: #CCC;    
 }
div.body {
    background: white;
    border: solid 1px blackxs;
    width: 800px;
    xheight: 100px;
    xbackground-color: red;

    position: absolute;
    top: 10px
    bottom: 0;
    left: 0;
    right: 0;

    padding: 10px;
    margin: auto;
}

/**
 * Inspired by github's default code highlighting
 */
pre { white-space: pre; background-color: #f8f8f8; border: 1px dotted blue; font-size: 11px; line-height: 12px; overflow: auto; padding: 6px 10px; border-radius: 3px; margin-left: 5px; margin-right: 5px; }

")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro while (test &body body)
  `(do ()
       ((not ,test))
     ,@body))

(defun prefixp (line str &aux (max (length str)))
  (and (>= (length line) max)
       (string= str (subseq line 0 max))))

(defun prune (lst)
  (while (and lst (zerop (length (car lst))))
    (pop lst))
  lst)

(defun prep (lst)
  (prune  lst)
  (prune (reverse lst))
  (reverse lst))

(defun command-line ()
  (mapcar 'read-from-string
          (cdr #+clisp ext:*args*
               #+sbcl sb-ext:*posix-argv*
               #+clozure (ccl::command-line-arguments)
               #+gcl si:*command-args*
               #+ecl (loop for i from 0 below (si:argc) collect (si:argv i))
               #+cmu extensions:*command-line-strings*
               #+allegro (sys:command-line-arguments)
               #+lispworks sys:*line-arguments-list*)))   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
(defun codetext (ins outs &aux cache finale line)
   (labels ((code ()
              (when cache
                (format outs
                        "<div class=lispcode>
                         <pre class=lisp>~{~A~^~%~}</pre></div>~%"
                        (prep cache))
                (setf finale #'text
                      cache  nil)))
            (text ()
              (when cache
                (princ
                 (markdown.cl:parse
                  (format nil "~{~a~%~}~%" (prep cache)))
                 outs)
                (setf finale #'code
                      cache  nil))))
     (setf finale #'code)
     (while (setf line (read-line ins nil))
       (cond ((prefixp line "#|")  (code))
             ((prefixp line "|#")  (text))
             (t                    (push line cache))))
     (funcall finale)))

(defun main1  (stem input-stream output-stream)
  (format  output-stream *header* stem *style* *banner*)
  (codetext input-stream output-stream)
  (princ "</div></body></html>" output-stream))

(defun main  (stem)
  (let* ((lisp (string-downcase (format nil "~a.lisp"      stem)))
         (html (string-downcase (format nil "docs/~a.html" stem))))
    (when (probe-file lisp)
      (with-open-file
          (input-stream lisp :direction :input)
        (with-open-file
            (output-stream html :direction :output
                           :if-exists :supersede
                           :if-does-not-exist :create)
            (main1 stem input-stream output-stream))))))

(mapc #'main (command-line))
