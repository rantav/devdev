#!/bin/bash

function install_npm_g() {
  local package=$1
  npm ls -g $package | grep $package || npm i -g $package
}

function install_gem() {
  local gem=$1
  gem list $gem | grep $gem || gem install $gem
}
echo
echo "Checking for existing componenents and installing on demand..."
echo "=============================================================="
echo
which meteor || curl https://install.meteor.com | /bin/sh
which mrt || npm install -g meteorite
#which mocha || npm install -g mocha

# Test setup:
install_npm_g "karma@0.8.6"
install_npm_g "phantomjs@1.9.0-6"
install_npm_g "istanbul@0.1.39"
install_npm_g "grunt-cli"
install_npm_g "selenium-webdriver"
install_npm_g "jasmine-node"

# growl (optional)
# MAC:
install_gem "terminal-notifier"
# LINUX:
# $ sudo apt-get install libnotify-bin

echo
echo DONE
echo