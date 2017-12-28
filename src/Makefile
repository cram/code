Name=Tim Menzies
Email=tim@menzies.us

edit:
	vim -u dotvimrc $f

me:
	@$(MAKE) Name="Tim Menzies" Email="tim@menzies.us" gitting

gitting:
		@git config --global push.default matching
	@git config user.name "$(Name)"
	@git config user.email "$(Email)"
	@git config --global credential.helper cache
	@git config credential.helper 'cache --timeout=3600'
	@git config --global user.email "$(Email)"
	@git config --global user.name "$(Name)"

push: gitting
	@git status
	@git commit -am updated
	@git push

pull: gitting
	@git pull

play:
	sbcl --noinform
	
tdd:
	$(MAKE) \
         Args="$(wordlist 3,$(words $(RUN_ARGS)),$(RUN_ARGS))"\
         Main="$(word 2, $(RUN_ARGS))"\
         sbcl

FFT=sh lisp fft

eg1:; @$(FFT) keyTest :aa 1000000

EGS=$(shell egrep '^eg' Makefile | awk -F: '{s = s " "$$1} END {print s}')

demo:
	@$(MAKE)  $(EGS)
