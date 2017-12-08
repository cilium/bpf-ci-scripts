#!/bin/bash

set -x

LLVM_TREE=/src/llvm
BUILD_DIR=$LLVM_TREE/build

mkdir -pv $BUILD_DIR
cd $BUILD_DIR

cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
  	 -DBUILD_SHARED_LIBS=OFF \
  	 -DCMAKE_BUILD_TYPE=Release \
  	 -DLLVM_BUILD_RUNTIME=OFF
make -j $(getconf _NPROCESSORS_ONLN)
