#!/bin/bash
for stride in 16 32 64 128 256 512
do
    ./main $stride table$stride 1000
    ./crunch 1000 table$stride
done

python plot.py 16 32 64 128 256 512