#!/bin/bash
# Runs the LLVM flow for one kernel: source -> IR -> window-loop unrolling ->
# HwSwPartition pass -> generated HLS kernel + rewritten software IR -> full-image check.
set -e
K=$1
ROOT=/mnt/d/Ayah/Percobaan2
KD=$ROOT/kernels/$K
G=$KD/gen
CLANG=clang-18; CLANGXX=clang++-18; OPT=opt-18
PLUGIN=$ROOT/pass/build/HwSwPartition.so
mkdir -p $G

$CLANG -O1 -funroll-loops -fno-discard-value-names -emit-llvm -S -x c++ $KD/ref.cpp -o $G/ref_O1.ll
# Fully unroll the fixed-size window loops (trip count <= 25) but keep the image loops.
$OPT -S -unroll-full-max-count=25 -unroll-threshold=100000 \
     -passes='function(loop(loop-unroll-full),sroa,instcombine,simplifycfg,loop(loop-unroll-full),sroa,instcombine,simplifycfg,early-cse,instcombine,simplifycfg)' \
     $G/ref_O1.ll -o $G/ref_pre.ll
$OPT -S -load-pass-plugin=$PLUGIN -passes='hwsw-partition' -hwsw-kernel=$K -hwsw-out-dir=$G \
     $G/ref_pre.ll -o $G/annotated.ll
$OPT -S -passes='dce,simplifycfg' $G/annotated.ll -o $G/sw.ll

$CLANGXX -O1 -DHWSW_VERIFY -I/mnt/e/Xilinx/Vitis_HLS/2023.2/include -I$KD -I$ROOT/common \
     -Wno-unused-value $G/hw.cpp $G/sw.ll $ROOT/common/verify.cpp -o $G/verify
$G/verify
