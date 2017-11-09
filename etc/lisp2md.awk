BEGIN {In=1}

function toggle() {
    if (In) {
        print "```"
        In=0
    } else {
        print "```lisp"
        In=1 }}


$1=="#""|" && pass==1 {
    $1 =";"
    print $0
    while ((getline  ) > 0) {
        if ($1 == "|#") {
            $1=";"
            print $0
            break
        } else {
            print ";" $0
        } 
    }
    next
}
$0~/^;/ {
    if 
{print}
# /^x[;+]/ {
#     sub(/^[;+]/,"")
#     print $0
#     toggle()
#     next
# }
#    { print }
# END {
#     if (In) toggle()
# }
