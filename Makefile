deploy:
	bash deploy.sh

setup:
	bash setup.sh

test:
	bash mocha --compilers coffee:coffee-script --recursive

test-watch:
	mocha --compilers coffee:coffee-script --recursive -w

# see http://stackoverflow.com/questions/3931741/why-does-make-think-the-target-is-up-to-date
.PHONY: test