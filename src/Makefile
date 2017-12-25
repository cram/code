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


