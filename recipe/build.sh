#!/bin/bash

export CPPFLAGS="-I${PREFIX}/include"

./configure --prefix="${PREFIX}" --with-libctl=no

make -j ${CPU_COUNT}
export OPENBLAS_NUM_THREADS=1
otool -l $SRC_DIR/src/.libs/libmeep.dylib
exit 1
# pushd tests && make -j ${CPU_COUNT} check && popd
make install

rm ${SP_DIR}/meep/_meep.a
rm ${PREFIX}/lib/libmeep.a
