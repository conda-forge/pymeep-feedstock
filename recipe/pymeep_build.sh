#!/bin/bash
set -ex

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

# Fix compatibility with python 3.12
# https://github.com/NanoComp/meep/pull/3028
sed -i.bak "s|import distutils\.sysconfig; print *(distutils\.sysconfig\.get_python_inc())|import sysconfig; print(sysconfig.get_path('include'))|" configure

./configure --prefix="${PREFIX}" --with-libctl=no ${WITH_MPI} || cat config.log

make -j ${CPU_COUNT}
export OPENBLAS_NUM_THREADS=1
pushd tests
make -j ${CPU_COUNT} check
popd
make install

rm -f ${SP_DIR}/meep/_meep.a
rm -f ${PREFIX}/lib/libmeep.a
