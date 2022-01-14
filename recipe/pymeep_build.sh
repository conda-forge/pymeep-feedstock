#!/bin/bash

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

# paranoia: sometimes autoconf doesn't get things right the first time
autoreconf --verbose --install --symlink --force
autoreconf --verbose --install --symlink --force
autoreconf --verbose --install --symlink --force

./configure --prefix="${PREFIX}" --with-libctl=no ${WITH_MPI}

make -j ${CPU_COUNT}
export OPENBLAS_NUM_THREADS=1
pushd tests && make -j ${CPU_COUNT} check && popd
make install

rm ${SP_DIR}/meep/_meep.a
rm ${PREFIX}/lib/libmeep.a
