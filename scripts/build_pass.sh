#!/bin/bash
set -e
cd /mnt/d/Ayah/Percobaan2/pass
mkdir -p build
clang++-18 -shared -fPIC -O2 $(llvm-config-18 --cxxflags) HwSwPartition.cpp -o build/HwSwPartition.so
echo built
