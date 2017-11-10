# rpm= recursive pandoc make

#Full pathnames: 
Root=$(PWD)# top
Targets=$(Root)#                        Targetsput dir
Sources=$(Root)/_files#                     source
Spandoc=$(Root)/_spandoc

define theBibrefs
@Misc{timm15,
  title="SPANDOC: Generating static web sites via Recursive Pandoc",
  author="Tim Menzies",
  year=2015,
  notes="Web site: http://spandoc.github.io"
}
endef
export theBibrefs

define theMkd2html
pandoc -s  --webtex -i -t slidy \\
    -r markdown+simple_tables+table_captions \\
    --biblio $$1/refs.bib \\
    -c "http://www.w3.org/Talks/Tools/Slidy2/styles/slidy.css" \\
    -r markdown+simple_tables+table_captions  \\
    -o $$3 $$2
endef
export theMkd2html

define theMd2html
pandoc -s  \\
  --toc\\
  --biblio $$1/refs.bib \\
  -c  img/page.css \\
  -r markdown+simple_tables+table_captions+pipe_tables \\
  -B $$1/before.html \\
  -A $$1/after.html \\
  -o $$3 $$2
endef
export theMd2html

define theBefore
<div id="wrapper"> 
<a href="https://twitter.com/hashtag/spandoc?src=hash"><img  id=twitter src="img/twitter-24.png"

></a><a href="https://github.com/spandoc/spandoc.github.io"><img id=github src="img/github-24.png"
></a><h1>This is SPANDOC </h1>
<div id="navcontainer">
            <ul id="navlist">
                <li><a href="index.html">Home</a></li>
                <li><a href="about.html">About</a></li>
                <li><a href="faq.html">FAQ</a></li>
                <li><a href="Contact.html">Contact</a></li>
            </ul>
        </div>
    <hr>
endef
export theBefore

define theAfter
<hr>
   <span id=footer>
      <p> 
tim.menzies@gmail.com wrote this file.  Please consider
retaining the following notice with this code. 
If we meet some day, and you think
this stuff is worth it, you can buy me a beer in return.   
      </p><p>
Just to be clear,  anybody caught using this code without 
our permission, will be mighty good friends of own, cause I don’t 
give a dern. Publish it. Write it. Sing it. Swing to it. Yodel it. 
I wrote it, that’s all we wanted to do. 
     </p>
  </span>
</div>
endef
export theAfter

define thePagecss 
body{
margin:0;padding:0;background:#FFFFFF;
font-family: "Helvetica Neue", Helvetica, "Open Sans", Arial, sans-serif;
background-color:#CCC;
}
#wrapper {
width: 800px;
height: 100%;
min-height: 100%;
border: black 1px solid;
background-color: #FFF;
padding: 20px;
margin: 0 auto;
margin-top: 20px;
}
html>body #wrapper {
height: auto;
}
h1, h2, h3{
margin:0;
padding:0;
font-weight:normal;
color:#555;
}
h1{font-size:3.5em;}
h2{font-size:2.4em;}
h3{font-size:1.6em;}
p, ul, ol{
margin-top:0;
line-height:180%;
}
a{
text-decoration:underline;
color: Teal ;
} 

ul#navlist
{
margin-left: 0;
padding-left: 0;
white-space: nowrap;
}

#navlist li
{
display: inline;
list-style-type: none;
}

#navlist a { padding: 3px 10px; }

#navlist a:link, #navlist a:visited
{
color: #fff;
background-color: Teal;
text-decoration: none;
}

#navlist a:hover
{
color: #fff;
background-color: #369;
text-decoration: none;
}
#footer {
font-family: Courier; 
font-size: x-small;
font-weight: bold;
}
#github img { 
float:right; 
margin-right: 1px;
background-color: red;
}

endef
export thePagecss

define theYuml2png
  cat $$ | yuml -s scruffy -o $$3
endef
export theYuml2png

##############################

Ignore=grep -v _ | egrep -v '^\.\/\.'  | grep -v '^\.$$' | grep -v Makefile

dirs2do=$(shell find . -maxdepth 1  -type d  | $(Ignore))

define files2do
	$(shell find . -maxdepth 1  -type f  | $(Ignore) \
	 | awk '{print "$(There)/" $$1}')
endef

define worker
   cd $(realpath $(1)); \
   $(MAKE) -s -f $(Root)/Makefile Root=$(Root) Here=$(realpath $(1)) sub;
endef

Here=$(PWD)#
There=$(subst $(Sources),$(Targets),$(Here))#
Goals=$(subst .md,.html,\
      $(subst .mkd,.html,\
        $(subst .dot,.png,\
          $(subst .plt,.png,\
             $(call files2do)))))

.PHONY: all commit dirs gitting includes install \
        save scripts spandocs  status  sub  \
        there typo  update    

all: dirs spandocs
	@$(call worker,$(Sources))

spandocs: dirs scripts includes
	@chmod +x $(Spandoc)/*

scripts:  $(Spandoc)/yuml2png $(Spandoc)/md2html $(Spandoc)/mkd2html
includes: $(Spandoc)/page.css $(Spandoc)/refs.bib \
          $(Spandoc)/before.html $(Spandoc)/after.html

$(Spandoc)/yuml2png    : $(Root)/Makefile ; @echo "$$theYuml2png" > $@
$(Spandoc)/page.css    : $(Root)/Makefile ; @echo "$$thePagecss"  > $@
$(Spandoc)/md2html     : $(Root)/Makefile ; @echo "$$theMd2html"  > $@
$(Spandoc)/mkd2html    : $(Root)/Makefile ; @echo "$$theMkd2html" > $@
$(Spandoc)/refs.bib    : $(Root)/Makefile ; @echo "$$theBibrefs"  > $@
$(Spandoc)/after.html  : $(Root)/Makefile ; @echo "$$theAfter"    > $@
$(Spandoc)/before.html : $(Root)/Makefile ; @echo "$$theBefore"   > $@

dirs:
	@mkdir -p $(Targets) $(Sources) $(Spandoc) $(Root)/img
	 
	 
sub: there $(Goals) 
	@$(echo $(PWD))
	@$(foreach d,$(dirs2do), $(call worker,$d))

setup:
	sudo apt-get install pandoc pandoc-citeproc gnuplot graphviz
	sudo pip install https://github.com/wandernauta/yuml/zipball/master	

there:
	$(shell mkdir -p $(There))
	
commit: all save
save:  ; - git status; git commit -a; git push origin master
typo:  ; - git status; git commit -am "typo"; git push origin master
update:; - git pull origin master
status:; - git status
gitting:
	git config --global credential.helper cache
	git config credential.helper 'cache --timeout=3600'

$(There)/%.html : %.mkd  ; $(Spandoc)/mkd2html $(Spandoc) $< $@ 
$(There)/%.html : %.md   ; $(Spandoc)/md2html  $(Spandoc) $< $@
$(There)/%.png  : %.yuml ; $(Spandoc)/yuml2png $(Spandoc) $< $@
$(There)/%.png  : %.dot  ; dot -Tpng -o $@ $<
$(There)/%.png  : %.plt  ; gnuplot $< >$@
$(There)/%      : %      ; - cp $< $@
