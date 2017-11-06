#It can be downloaded from $(DOWNLOAD_URL).

D=.

all: $D/.gitignore

$D/.gitignore: $D/etc/dotgitignore  
	@cat $< > $@
	git  add $@

ide: etc/dotbashrc
	D="$(PWD)" bash --init-file etc/dotbashrc -i

