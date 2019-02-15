#!/bin/bash

export CPPFLAGS="-I${PREFIX}/include"

./configure --prefix="${PREFIX}" --with-libctl=no

make -j ${CPU_COUNT}
export OPENBLAS_NUM_THREADS=1
pushd tests && make -j ${CPU_COUNT} check || (cat ./test-suite.log && exit 1)
popd
make install

rm ${SP_DIR}/meep/_meep.a
rm ${PREFIX}/lib/libmeep.a
