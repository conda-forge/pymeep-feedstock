#!/bin/bash

# Display commands being run.
set -x

export CPPFLAGS="-I${PREFIX}/include"

if [[ $(uname) == Darwin ]]; then
    # -dead_strip_dylibs causes the tests in make check to fail to find
    # the default_material global variable in libctlgeom (from libctl)
    export LDFLAGS="${LDFLAGS/-Wl,-dead_strip_dylibs/}"
fi

if [[ ! -z "$mpi" && "$mpi" != "nompi" ]]; then
    export CC="${PREFIX}/bin/mpicc"
    export CXX="${PREFIX}/bin/mpic++"
    export WITH_MPI="--with-mpi"
else
    export WITH_MPI=""
fi

./configure --prefix="${PREFIX}" --with-libctl=no ${WITH_MPI} || cat config.log

make -j ${CPU_COUNT}
export OPENBLAS_NUM_THREADS=1
pushd tests && make -j ${CPU_COUNT} check && popd
make install

echo "SP_DIR=${SP_DIR}"
find ${SP_DIR} -name _meep.a
ls -alhtr ${SP_DIR}
find . -name _meep.a


export SP_DIR="/home/conda/feedstock_root/build_artifacts/pymeep_1697726182291/_h_env_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_plac/lib"
find ${SP_DIR} -name _meep.a
ls -alhtr ${SP_DIR}

echo "PREFIX=${PREFIX}"
find . -name libmeep.a
find ${PREFIX} -name libmeep.a
ls -alhtr ${PREFIX}/lib/

# rm ${SP_DIR}/meep/_meep.a
rm ${PREFIX}/lib/libmeep.a

python3 --version
echo "PYTHONPATH=${PYTHONPATH}"
python3 -c "import sys; print(sys.path)"
