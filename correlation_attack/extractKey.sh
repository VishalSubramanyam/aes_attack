#!/usr/bin/env bash
CACHE_LINE_SIZE=128
# first argument -> key byte position
# all key bytes until and including the key byte position are
# placed into keyFile.dat
echo "" > keyFile.dat
PYTHON_SCRIPT="\
import numpy as np
corrArray = \$(cat byte\${i}/cacheLineSize\${CACHE_LINE_SIZE}/corFile.txt)
print(np.argmin(corrArray))\
"
for i in {0..$1}
do
    python -c "${PYTHON_SCRIPT}" >> keyFile.dat
done
