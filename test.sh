#!/bin/bash

pushd test/rtd
PHANTOMJS_BIN=`which phantomjs` ./rtd
popd