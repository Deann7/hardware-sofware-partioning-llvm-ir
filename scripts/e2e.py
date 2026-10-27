# End-to-end full-image time per variant (64x64), from cosim cycles at the 100 MHz system
# clock, plus a CPU-only ARM Cortex-A9 estimate from dynamic instruction counts (qemu-arm)
# at 667 MHz with CPI between 1 and 2. Writes results/e2e.csv.
import csv
rows = list(csv.DictReader(open('results/summary.csv')))
arm = {(r['kernel'], r['opt']): int(r['instr_per_image']) for r in csv.DictReader(open('results/arm_count.csv'))}
NIMG = 3
out = [['kernel', 'variant', 'cycles_per_image', 'us_per_image_100MHz', 'frames_per_s',
        'speedup_vs_armO3_cpi1', 'speedup_vs_armO3_cpi2']]
for k in ['sobel', 'gauss', 'median', 'conv5']:
    a1 = arm[(k, 'O3')] / 667.0          # us at CPI 1
    a2 = 2 * a1                           # us at CPI 2
    out.append([k, 'cpu_armO2', '', f"{arm[(k,'O2')]/667.0:.1f}-{2*arm[(k,'O2')]/667.0:.1f}", '', '', ''])
    out.append([k, 'cpu_armO3', '', f"{a1:.1f}-{a2:.1f}", '', '1.00', '1.00'])
    for r in rows:
        if r['kernel'] != k:
            continue
        v = r['variant']
        cyc = float(r['cosim_lat_avg']) if v.startswith('mono') or v.endswith('stream') else float(r['cosim_total_cyc']) / NIMG
        us = cyc / 100.0
        out.append([k, v, f"{cyc:.0f}", f"{us:.1f}", f"{1e6/us:.0f}", f"{a1/us:.2f}", f"{a2/us:.2f}"])
w = csv.writer(open('results/e2e.csv', 'w', newline=''))
w.writerows(out)
for o in out:
    print(','.join(o))
