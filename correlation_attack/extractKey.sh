#!/usr/bin/env bash
CACHE_LINE_SIZE=128
# first argument -> key byte position
# all key bytes until and including the key byte position are
# placed into keyFile.dat
rm keyFile.dat

for i in $(seq 0 $1)
do
        PYTHON_SCRIPT="import numpy as np;corrArray = $(cat byte${i}/cacheLineSize${CACHE_LINE_SIZE}/corFile.txt);corrArray=[abs(i) for i in corrArray];print(np.argmax(corrArray))"
    python -c "${PYTHON_SCRIPT}" >> keyFile.dat
done
