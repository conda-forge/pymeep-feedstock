#!/bin/bash

export CPPFLAGS="-I${PREFIX}/include"

./configure --prefix="${PREFIX}" --with-libctl=no

make -j ${CPU_COUNT}
export OPENBLAS_NUM_THREADS=1
pushd tests && make -j ${CPU_COUNT} check && popd
pushd libmeepgeom && make -j ${CPU_COUNT} check && popd
make install

rm -f ${SP_DIR}/meep/_meep.a
rm -f ${PREFIX}/lib/libmeep.a
rm -f ${PREFIX}/lib/libmeepgeom.a
