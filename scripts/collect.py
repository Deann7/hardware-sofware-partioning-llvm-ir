"""Collect HLS / cosim / Vivado P&R metrics for every project into results/summary.csv.

Reads hls/prj when the full Vitis projects are present, otherwise the archived reports in hls/reports."""
import csv, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PRJ = os.path.join(ROOT, "hls", "prj")
if not os.path.isdir(PRJ):
    PRJ = os.path.join(ROOT, "hls", "reports")


def read(path):
    try:
        with open(path, encoding="utf8", errors="ignore") as f:
            return f.read()
    except OSError:
        return ""


def first(pattern, text, cast=str, flags=0):
    m = re.search(pattern, text, flags)
    return cast(m.group(1)) if m else ""


def collect(name):
    kernel, variant = name.split("_", 1)
    sol = os.path.join(PRJ, name, "solution1")
    log = read(os.path.join(ROOT, "hls", "logs", name + ".log"))
    row = {"kernel": kernel, "variant": variant}

    csynth = read(os.path.join(sol, "syn", "report", "csynth.rpt"))
    # Top module row: |+ top | issue | slack | latency | latency ns | iter lat | interval | trip | pipelined | BRAM | DSP | FF | LUT | URAM |
    m = re.search(r"^\s*\|\+ (\S+)\s*\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|", csynth, re.M)
    if m:
        row["hls_issue"] = m.group(2).strip()
        row["hls_latency_cyc"] = m.group(4).strip()
        row["hls_interval"] = m.group(7).strip()
    row["final_II"] = ";".join(re.findall(r"Final II = (\d+)", log))
    row["hls_est_clk_ns"] = first(r"Estimated Fmax.*?\n.*?(\d+\.\d+)", csynth)
    size = read(os.path.join(sol, "syn", "report", "csynth_design_size.rpt"))
    counts = re.findall(r"^\|\s*(Compile/Link|Unroll/Inline|Array/Struct|Performance|HW Transforms)?\s*\|[^|]*\|\s*(\d+)\s*\*?\s*\|", size, re.M)
    row["hls_instr_first"] = counts[0][1] if counts else ""
    row["hls_instr_final"] = counts[-1][1] if counts else ""

    cos = ""
    rep_dir = os.path.join(sol, "sim", "report")
    if os.path.isdir(rep_dir):
        for f in os.listdir(rep_dir):
            if f.endswith("_cosim.rpt"):
                cos = read(os.path.join(rep_dir, f))
    m = re.search(r"\|\s*Verilog\|\s*(\w+)\|" + r"\s*([\dNA]+)\|" * 7, cos)
    if m:
        row["cosim_status"] = m.group(1)
        row["cosim_lat_min"], row["cosim_lat_avg"], row["cosim_lat_max"] = m.group(2), m.group(3), m.group(4)
        row["cosim_total_cyc"] = m.group(8)
    row["tb"] = "PASS" if "TEST PASSED" in log else ("FAIL" if "TEST FAILED" in log else "")

    impl = read(os.path.join(sol, "impl", "report", "verilog", "export_impl.rpt"))
    for res in ("LUT", "FF", "DSP", "BRAM", "SRL"):
        row["impl_" + res] = first(r"^%s:\s+(\d+)" % res, impl, flags=re.M)
    row["post_syn_ns"] = first(r"\| Post-Synthesis \| ([\d.]+)", impl)
    row["post_route_ns"] = first(r"\| Post-Route\s+\| ([\d.]+)", impl)
    row["timing_met"] = "yes" if "Timing was met" in impl else ("no" if impl else "")
    if row["post_route_ns"]:
        row["fmax_MHz"] = "%.1f" % (1000.0 / float(row["post_route_ns"]))
    return row


def main():
    rows = [collect(n) for n in sorted(os.listdir(PRJ)) if os.path.isdir(os.path.join(PRJ, n))]
    keys = []
    for r in rows:
        for k in r:
            if k not in keys:
                keys.append(k)
    os.makedirs(os.path.join(ROOT, "results"), exist_ok=True)
    out = os.path.join(ROOT, "results", "summary.csv")
    with open(out, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=keys)
        w.writeheader()
        w.writerows(rows)
    w = csv.DictWriter(sys.stdout, fieldnames=keys)
    w.writeheader()
    w.writerows(rows)


if __name__ == "__main__":
    main()
