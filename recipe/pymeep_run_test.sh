#!/bin/bash

if [[ ! -z "$mpi" && "$mpi" != "nompi" ]]; then
    for t in python/tests/*.py; do
        if [ "$(basename $t)" != "material_dispersion.py" -a "$(basename $t)" != "mpb.py" ]; then
            echo "Running $(basename $t)"
            OPENBLAS_NUM_THREADS=1 ${PREFIX}/bin/mpiexec -n 2 $PYTHON $t
        fi
    done
else
    OPENBLAS_NUM_THREADS=1 find python/tests -name "*.py" | sed /mpb/d | parallel "$PYTHON {}"
fi
