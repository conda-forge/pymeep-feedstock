#!/bin/bash

export CPPFLAGS="-I${PREFIX}/include"

./configure --prefix="${PREFIX}" --with-libctl=no

make V=1 -j ${CPU_COUNT}
export OPENBLAS_NUM_THREADS=1
otool -L $SRC_DIR/src/.libs/libmeep.dylib
pushd tests && make -j ${CPU_COUNT} check || (otool -L $SRC_DIR/tests/pw-source-ll && exit 1)
popd
make install

rm ${SP_DIR}/meep/_meep.a
rm ${PREFIX}/lib/libmeep.a
