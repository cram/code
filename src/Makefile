###;;; args wont wolf for ":key" args
#If the first argument is "ing"...
ifeq (tdd,$(firstword $(MAKECMDGOALS)))
   # use the rest as arguments for "run"
   RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
   # ...and turn them into do-nothing targets
   $(eval $(RUN_ARGS):;@:)
endif

me:
	@$(MAKE) Name="Tim Menzies" Email="tim@menzies.us" gitting

gitting:
	@git config user.name "$(Name)"
	@git config user.email "$(Email)"
	@git config --global credential.helper cache
	@git config credential.helper 'cache --timeout=3600'

push: gitting
	@git status
	@git commit -am updated
	@git push

pull: gitting
	@git pull

tdd:
	$(MAKE) \
         Args="$(wordlist 3,$(words $(RUN_ARGS)),$(RUN_ARGS))"\
         Main="$(word 2, $(RUN_ARGS))"\
         sbcl

sbcl:
	echo sbcl --noinform \
		--disable-debugger \
		--eval  '(push :tdd *features*)' \
		--load "$(Main).lisp"  "$(Args)"
