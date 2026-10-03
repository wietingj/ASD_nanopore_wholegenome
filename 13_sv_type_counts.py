#!/usr/bin/env python3
"""SV counts by type in the ASD and NC call sets (SFARI gene regions) and bar plot.
Usage: 13_sv_type_counts.py ASD_SFARI.vcf NC_SFARI.vcf sv_types.png
"""
import collections
import re
import sys

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np


def count_sv_types(vcf):
    counts = collections.Counter()
    with open(vcf) as fh:
        for line in fh:
            if not line.startswith("#"):
                m = re.search(r"SVTYPE=([^;]+)", line.split("\t")[7])
                if m:
                    counts[m.group(1).strip()] += 1
    return counts


asd, nc = count_sv_types(sys.argv[1]), count_sv_types(sys.argv[2])
types = sorted(set(asd) | set(nc))

print("SVTYPE\tASD\tNC")
for t in types:
    print(f"{t}\t{asd.get(t, 0)}\t{nc.get(t, 0)}")
print(f"total\t{sum(asd.values())}\t{sum(nc.values())}")

x, w = np.arange(len(types)), 0.35
fig, ax = plt.subplots()
for offset, counts, label, color in ((0, asd, "ASD", "blue"), (w, nc, "NC", "orange")):
    bars = ax.bar(x + offset, [counts.get(t, 0) for t in types], w, label=label, color=color)
    ax.bar_label(bars)
ax.set_xlabel("SV Type")
ax.set_ylabel("Count")
ax.set_title("SV Type Distribution in ASD and NC Groups (SFARI genes)")
ax.set_xticks(x + w / 2)
ax.set_xticklabels(types, rotation=45)
ax.legend()
fig.tight_layout()
fig.savefig(sys.argv[3], dpi=300)
