run:
	pushd app && mrt --settings settings.dev.json ; popd

deploy:
	bash deploy.sh

deploy-no-tag:
	pushd app; mrt deploy devdev.io; popd

setup:
	bash setup.sh

test:
	bash test.sh

# see http://stackoverflow.com/questions/3931741/why-does-make-think-the-target-is-up-to-date
.PHONY: test