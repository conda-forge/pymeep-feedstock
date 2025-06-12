#!/bin/bash

pip check || exit 1

if [[ ! -z "$mpi" && "$mpi" != "nompi" ]]; then
    for t in python/tests/*.py; do
        if [ "$(basename $t)" != "test_material_dispersion.py" -a "$(basename $t)" != "test_mpb.py" -a "$(basename $t)" != 'test_adjoint_*.py' ]; then
            echo "Running $(basename $t)"
            OPENBLAS_NUM_THREADS=1 ${PREFIX}/bin/mpiexec -n 2 $PYTHON $t
        fi
    done
else
    OPENBLAS_NUM_THREADS=1 find python/tests -name "*.py" | sed /mpb/d | sed /adjoint/d | parallel "$PYTHON {}"
fi
