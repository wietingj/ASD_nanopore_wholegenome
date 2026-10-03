#!/usr/bin/env python3
"""Collect mosdepth mean coverage and cramino alignment statistics of all samples.
Usage: 04_collect_qc.py <qc_dir> qc_summary.tsv
"""
import csv
import glob
import os
import sys

FIELDS = ["Number of alignments", "% from total reads", "Yield [Gb]", "N50",
          "Median length", "Mean length", "Median identity", "Mean identity"]

qc_dir, out = sys.argv[1], sys.argv[2]

with open(out, "w", newline="") as fh:
    w = csv.writer(fh, delimiter="\t")
    w.writerow(["Sample", "Mean coverage"] + FIELDS)
    for f in sorted(glob.glob(os.path.join(qc_dir, "*.cramino.txt"))):
        sample = os.path.basename(f)[:-len(".cramino.txt")]
        d = {}
        with open(f, encoding="latin-1") as fin:
            for line in fin:
                p = line.rstrip("\n").split("\t")
                if len(p) >= 2:
                    d[p[0]] = p[1]
        cov = ""
        with open(os.path.join(qc_dir, sample + ".mosdepth.summary.txt")) as fin:
            for line in fin:
                p = line.split("\t")
                if p[0] == "total":
                    cov = p[3]
        w.writerow([sample, cov] + [d.get(k, "") for k in FIELDS])
