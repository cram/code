echo "patching $1"

stem=$(basename $1 '.html')
org=lispth

icon='https://raw.githubusercontent.com/lispth/code/master/etc/img/lambda.ico'
img='https://avatars1.githubusercontent.com/u/33398802?s=200&v=4'

_docheader() { 

name="LISPTH: $1"

if [[ "$1" == "index" ]]; then
  name="LISPTH: Data Mining in Lisp"
fi

cat<<EOF
 <a href="https://github.com/$org/${org}.github.io"><img z-index: 1
style="position: absolute; top: 0; right: 0; border: 0;" 
src="https://camo.githubusercontent.com/38ef81f8aca64bb9a64448d0d70f1308ef5341ab/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6461726b626c75655f3132313632312e706e67" 
alt="Fork me on GitHub" 
data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png"></a>
<img width=150 align=right src="$img">
<p>
<a href="index.html">home</a> |
<a href="https://github.com/${org}/code/issues">issues</a> |
<a href="https://${org}.github.io/LICENSE">license</a> 
</p>
<h1> 
$name
</h1>
<hr>
EOF

}

str=$(_docheader $stem)
sed "s?</head>?<link rel=\"shortcut icon\" type=\"image/x-icon\" href="$icon"></head>?"  $1 > /tmp/$$
gawk '/<h1>/ {print str; next} /<.h1>/ {next} {print}' str="$str"  /tmp/$$ > /tmp/a$$
mv /tmp/a$$  $1
     
