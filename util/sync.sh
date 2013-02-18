#!/bin/bash

# The purpose is to sync up the "real" config folder to the "fakes".


cp -r ~/.config/devel-toolbox/ ./file
rm -rf ./file/config
mv ./file/devel-toolbox ./file/config

exit 0
