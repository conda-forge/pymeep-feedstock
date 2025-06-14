#!/bin/bash
set -ex

if [[ ! -z "$mpi" && "$mpi" != "nompi" ]]; then
    export CC="${PREFIX}/bin/mpicc"
    export CXX="${PREFIX}/bin/mpic++"
    export WITH_MPI="--with-mpi"
else
    export WITH_MPI=""
fi

# Fix compatibility with python 3.12
# https://github.com/NanoComp/meep/pull/3028
sed -i.bak "s|import distutils\.sysconfig; print *(distutils\.sysconfig\.get_python_inc())|import sysconfig; print(sysconfig.get_path('include'))|" configure

./configure --prefix="${PREFIX}" --with-libctl=no ${WITH_MPI} || cat config.log

make -j ${CPU_COUNT}

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
    # Only run tests if we are natively compiling or if we have an emulator
    # for example osx-arm64 cannot be emulated on osx-x86_64bit
    pushd tests
    OPENBLAS_NUM_THREADS=1 make -j ${CPU_COUNT} check
    popd
fi
make install

rm ${SP_DIR}/meep/_meep.a
rm ${PREFIX}/lib/libmeep.a
