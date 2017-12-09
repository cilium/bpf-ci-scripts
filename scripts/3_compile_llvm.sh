#!/bin/bash

set -xe

CLANG_SRC=/src/llvm/tools/clang
LLVM_SRC=/src/llvm
BUILD_DIR=$LLVM_SRC/build

echo "TODO: enable"
exit 0

git -C $LLVM_SRC pull origin master
git -C $CLANG_SRC pull origin master

mkdir -pv $BUILD_DIR
cd $BUILD_DIR

cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
  	 -DBUILD_SHARED_LIBS=OFF \
  	 -DCMAKE_BUILD_TYPE=Release \
  	 -DLLVM_BUILD_RUNTIME=OFF
make -j $(getconf _NPROCESSORS_ONLN)
