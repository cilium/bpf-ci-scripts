#!/bin/bash

set -x

vagrant scp :workspace/tools/testing/selftests/bpf/ ARTIFACTS/selftest-bpf
vagrant scp :workspace/.config ARTIFACTS/KernelConfig.txt || true
