#!/bin/bash

set -ex
pip check

unit_tests_dirname="python/tests/"
unit_tests=("test_antenna_radiation.py" "test_bend_flux.py" "test_binary_grating.py" "test_simulation.py")

if [[ ! -z "$mpi" && "$mpi" != "nompi" ]]; then
    for unit_test in "${unit_tests[@]}"; do
        echo "Running ${unit_test}"
        OPENBLAS_NUM_THREADS=1 ${PREFIX}/bin/mpiexec -n 2 ${PYTHON} ${unit_tests_dirname}${unit_test}
    done
else
    OPENBLAS_NUM_THREADS=1 parallel ${PYTHON} ${unit_tests_dirname}{} ::: "${unit_tests[@]}"
fi
