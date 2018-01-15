#!/bin/bash

set -x

rm -rvf ARTIFACTS || true
mkdir -pv ARTIFACTS
vagrant scp :workspace/tools/testing/selftests/bpf/ ARTIFACTS/selftest-bpf || true
vagrant scp :workspace/.config ARTIFACTS/KernelConfig.txt || true
vagrant scp :/tmp/*_result.txt ARTIFACTS/ || true
touch ARTIFACTS/empty_result.txt
vagrant ssh -c "df -h /"
