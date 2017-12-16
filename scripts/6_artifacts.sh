#!/bin/bash

set -x

vagrant scp :workspace/tools/testing/selftests/bpf/ ARTIFACTS/selftest-bpf || true
vagrant scp :workspace/.config ARTIFACTS/KernelConfig.txt || true
