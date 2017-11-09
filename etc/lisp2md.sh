awk 'BEGIN {In=0}
    /^[;+] / { sub(/^[;+] /,"")
               if (!In) {In=1; print "```"}
               print $0
             }
    /^#| / { sub(/^#| /,"")
             print $0
             while ((getline line ) > 0)
               if (line ~ /^|#/) {
                 sub(/^\|# /,"")
                 print $0
             }
            }
