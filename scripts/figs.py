# Figures for the manuscript: flow diagram, end-to-end time per image, post-route LUT/FF.
import csv
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch

plt.rcParams.update({'font.family': 'Times New Roman', 'font.size': 9})
OUT = 'results/figs/'
K = ['sobel', 'gauss', 'median', 'conv5']
KN = {'sobel': 'Sobel 3x3', 'gauss': 'Gaussian 3x3', 'median': 'Median 3x3', 'conv5': 'Gaussian 5x5'}

# Fig. 1: tool flow
fig, ax = plt.subplots(figsize=(7.0, 2.4)); ax.axis('off'); ax.set_xlim(0, 104); ax.set_ylim(4, 40)
def box(x, y, w, h, t, fc='#ffffff'):
    ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle='round,pad=0.4', fc=fc, ec='black', lw=0.8))
    ax.text(x + w / 2, y + h / 2, t, ha='center', va='center', fontsize=7)
def arr(x1, y1, x2, y2):
    ax.annotate('', (x2, y2), (x1, y1), arrowprops=dict(arrowstyle='->', lw=0.8))
box(1, 26, 12, 9, 'C/C++ kernel\n(ref.cpp)')
box(17, 26, 15, 9, 'clang -O1 +\nfull unroll, SROA,\ninstcombine')
box(36, 26, 18, 9, 'HwSwPartition pass\n(slice, SCEV offsets,\n!hwsw.partition)', '#e8e8e8')
box(60, 31, 17, 6, 'hw.cpp (ap_uint,\nHLS pragmas)')
box(60, 22, 17, 6, 'sw.ll (rewritten IR,\ncalls kernel)')
box(60, 13, 17, 6, 'driver.inc,\nmanifest.json')
box(84, 31, 19, 6, 'Vitis HLS 2023.2\ncsim / csynth / cosim')
box(84, 20, 19, 6, 'Vivado 2023.2\nsynth + P&R (OOC)')
box(84, 9, 19, 6, 'post-route\nLUT / FF / DSP / WNS')
box(36, 7, 18, 9, 'Full-image check:\nsw.ll linked with hw.cpp\nvs golden (bit-exact)')
arr(13.4, 30.5, 16.6, 30.5); arr(32.4, 30.5, 35.6, 30.5)
arr(54.4, 32.5, 59.6, 34); arr(54.4, 30.5, 59.6, 25); arr(54.4, 28.5, 59.6, 16)
arr(77.4, 34, 83.6, 34); arr(93.5, 30.6, 93.5, 26.4); arr(93.5, 19.6, 93.5, 15.4)
arr(45, 25.6, 45, 16.4)
fig.savefig(OUT + 'fig1_flow.png', dpi=300, bbox_inches='tight'); plt.close(fig)

# Fig. 2: end-to-end time per 64x64 image (log scale)
e = list(csv.DictReader(open('results/e2e.csv')))
V = [('cpu_armO3', 'ARM A9 -O3 (est., CPI 1-2)'), ('gen', 'Pass-generated, per-window AXI4-Lite'),
     ('manual', 'Manual, per-window AXI4-Lite'), ('mono_pipe', 'Monolithic HLS (m_axi, pipelined)'),
     ('stream', 'Streaming line buffer (AXI4-Stream)')]
gray = ['#bbbbbb', '#000000', '#555555', '#888888', '#ffffff']
hatch = ['//', '', '', '', '']
fig, ax = plt.subplots(figsize=(7.0, 2.8))
w = 0.16
for i, (v, lab) in enumerate(V):
    ys = []
    for k in K:
        r = next(r for r in e if r['kernel'] == k and r['variant'] == v)
        s = r['us_per_image_100MHz']
        ys.append(float(s.split('-')[1]) if '-' in s else float(s))
    lo = None
    if v == 'cpu_armO3':
        lo = [float(next(r for r in e if r['kernel'] == k and r['variant'] == v)['us_per_image_100MHz'].split('-')[0]) for k in K]
    xs = [j + (i - 2) * w for j in range(len(K))]
    ax.bar(xs, ys, w, label=lab, color=gray[i], edgecolor='black', hatch=hatch[i], lw=0.6)
    if lo:
        ax.errorbar(xs, ys, yerr=[[y - l for y, l in zip(ys, lo)], [0] * 4], fmt='none', ecolor='black', capsize=2, lw=0.6)
ax.set_yscale('log'); ax.set_ylabel('Time per 64x64 image (us)')
ax.set_xticks(range(len(K))); ax.set_xticklabels([KN[k] for k in K])
ax.legend(fontsize=7, ncol=2, frameon=False, loc='upper left', bbox_to_anchor=(0, 1.25))
ax.grid(axis='y', which='major', lw=0.3)
fig.savefig(OUT + 'fig2_e2e.png', dpi=300, bbox_inches='tight'); plt.close(fig)

# Fig. 3: post-route LUT and FF per variant
s = list(csv.DictReader(open('results/summary.csv')))
V3 = [('gen', 'Pass-generated'), ('manual', 'Manual window'), ('stream', 'Streaming'), ('mono_pipe', 'Monolithic (pipelined)')]
fig, axs = plt.subplots(1, 2, figsize=(7.0, 2.4))
for ax, key, title in [(axs[0], 'impl_LUT', 'LUT'), (axs[1], 'impl_FF', 'FF')]:
    for i, (v, lab) in enumerate(V3):
        ys = [int(next(r for r in s if r['kernel'] == k and r['variant'] == v)[key]) for k in K]
        ax.bar([j + (i - 1.5) * 0.2 for j in range(4)], ys, 0.2, label=lab, color=['#000000', '#555555', '#ffffff', '#aaaaaa'][i], edgecolor='black', lw=0.6)
    ax.set_title('Post-route ' + title, fontsize=9); ax.set_xticks(range(4)); ax.set_xticklabels([KN[k].replace(' ', '\n', 1) for k in K], fontsize=7.5)
    ax.grid(axis='y', lw=0.3)
fig.legend(*axs[0].get_legend_handles_labels(), fontsize=7.5, frameon=False, ncol=4, loc='upper center', bbox_to_anchor=(0.5, 1.08))
fig.tight_layout(); fig.savefig(OUT + 'fig3_area.png', dpi=300, bbox_inches='tight'); plt.close(fig)
print('ok')
