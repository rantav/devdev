#!/bin/bash

echo
echo "Checking for existing componenents and installing on demand..."
echo "=============================================================="
echo
which meteor || curl https://install.meteor.com | /bin/sh
which mrt || npm install -g meteorite
which mocha || npm install -g mocha
