run:
	pushd app && mrt ; popd

deploy:
	bash deploy.sh

deploy-no-tag:
	pushd app; mrt deploy devdev.io; popd

setup:
	bash setup.sh

test:
	pushd test/rtd && PHANTOMJS_BIN=`which phantomjs` ./rtd ; popd

# see http://stackoverflow.com/questions/3931741/why-does-make-think-the-target-is-up-to-date
.PHONY: test