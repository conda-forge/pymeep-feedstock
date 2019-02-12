#!/bin/bash

# OPENBLAS_NUM_THREADS=1 find python/tests -name "*.py" | sed /mpb/d | parallel "$PYTHON {}"

for $fname in *.py; do
    echo "Running $fname"
    OPENBLAS_NUM_THREADS=1 $PYTHON $fname
done
