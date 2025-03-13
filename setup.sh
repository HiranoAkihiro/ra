#!/bin/bash
git submodule update --init --recursive
cd submodule/monolis_utils
make clean
make
cd ../../
make clean
make