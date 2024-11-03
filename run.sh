#!/bin/bash

if [ $1 -eq 1 ]; then
    python3 ./src/01_make_blocks_main.py
elif [ $1 -eq 2 ];then
    make clean
    make
    python3 ./src/02_place_blocks_main.py
fi