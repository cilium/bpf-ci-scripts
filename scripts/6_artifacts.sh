#!/bin/bash

set -x

mkdir -pv ARTIFACTS
vagrant scp :workspace/tools/testing/selftests/bpf/ ARTIFACTS/selftest-bpf || true
vagrant scp :workspace/.config ARTIFACTS/KernelConfig.txt || true
vagrant scp :/tmp/*_result.txt ARTIFACTS/ || true
touch ARTIFACTS/empty_result.txt
