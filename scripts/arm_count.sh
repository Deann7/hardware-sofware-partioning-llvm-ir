#!/bin/bash
# Dynamic ARM instruction count of each software reference filter for one 64x64 image.
set -e
cd /mnt/d/Ayah/Percobaan2
out=results/arm_count.csv
echo "kernel,opt,instr_per_image" > $out
declare -A fn=([sobel]=sobel_codesign_filter [gauss]=gauss_filter [median]=median_filter [conv5]=conv5_filter)
for k in sobel gauss median conv5; do
  for o in O2 O3; do
    bin=/tmp/arm_${k}_$o
    arm-linux-gnueabihf-g++ -$o -mcpu=cortex-a9 -mfpu=neon -mfloat-abi=hard -static \
      -DKREF=${fn[$k]} -Ikernels/$k arm/armcount.cpp -o $bin
    c0=$(qemu-arm -one-insn-per-tb -d exec,nochain -D /dev/stdout $bin 0 | grep -c '^Trace')
    c1=$(qemu-arm -one-insn-per-tb -d exec,nochain -D /dev/stdout $bin 1 | grep -c '^Trace')
    echo "$k,$o,$((c1-c0))" | tee -a $out
  done
done
