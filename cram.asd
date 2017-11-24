;;;; cram.asd

(asdf:defsystem #:cram
  :description "Data mining, refactored, for teaching and research"
  :author "Tim Menzies <tim@menzies.us>"
  :license "MIT"
  :serial t
  :components ((:file "package")
               (:file "cram")))

