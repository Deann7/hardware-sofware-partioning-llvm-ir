#!/bin/bash
# Rebuilds the pass and reruns the LLVM flow for every kernel.
set -e
bash /mnt/d/Ayah/Percobaan2/scripts/build_pass.sh
for k in sobel gauss median conv5; do
  echo "== $k"; bash /mnt/d/Ayah/Percobaan2/scripts/partition.sh $k 2>&1 | tail -2
done
