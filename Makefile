run:
	pushd app && mrt ; popd

deploy:
	bash deploy.sh

setup:
	bash setup.sh

test:
	pushd test/rtd && ./rtd ; popd

# see http://stackoverflow.com/questions/3931741/why-does-make-think-the-target-is-up-to-date
.PHONY: test