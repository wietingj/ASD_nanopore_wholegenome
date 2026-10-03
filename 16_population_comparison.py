#!/usr/bin/env python3
"""Compare ASD-unique SVs with catalogued benign SVs integrated in AnnotSV
(incl. gnomAD-SV and HPRC).
DEL: reciprocal overlap >= 50 % with a catalogued benign deletion (B_loss_coord).
INS: catalogued benign insertion (span <= 1 kb) within 50 bp (B_ins_coord).
Usage: 16_population_comparison.py AnnotSV_ASD_unique_SFARI.tsv population_comparison.tsv
"""
import re
import sys
import numpy as np
import pandas as pd

d = pd.read_csv(sys.argv[1], sep="\t", low_memory=False)
full = d[d["Annotation_mode"] == "full"].copy()
split = d[d["Annotation_mode"] == "split"]

genes = split.groupby("AnnotSV_ID")["Gene_name"].agg(lambda x: ";".join(dict.fromkeys(map(str, x))))
full["genes"] = full["AnnotSV_ID"].map(genes)

is_del = full["SV_type"] == "DEL"
full["AFmax"] = np.where(is_del, pd.to_numeric(full["B_loss_AFmax"], errors="coerce"),
                         pd.to_numeric(full["B_ins_AFmax"], errors="coerce"))
full["B_source"] = np.where(is_del, full["B_loss_source"], full["B_ins_source"])
full["B_coord"] = np.where(is_del, full["B_loss_coord"], full["B_ins_coord"])


def coords(c):
    if pd.isna(c):
        return []
    hits = (re.match(r"(?:chr)?[0-9XY]+:(\d+)-(\d+)", t.strip()) for t in str(c).split(";"))
    return [(int(m.group(1)), int(m.group(2))) for m in hits if m]


def best_match(r):
    cs = coords(r["B_coord"])
    if not cs:
        return np.nan
    s, e = r["SV_start"], r["SV_end"]
    if r["SV_type"] == "DEL":
        return max(max(0, min(e, b) - max(s, a)) / max(e - s, b - a) for a, b in cs)
    return max(1.0 if (b - a) <= 1000 and abs(a - s) <= 50 else 0.0 for a, b in cs)


def has(src, names):
    return "yes" if any(n in str(src) for n in names) else "no"


full["match"] = full.apply(best_match, axis=1)
full["category"] = np.select([full["match"].isna(), full["match"] >= 0.5],
                             ["no catalogued benign SV", "matched"], "larger region only")
full["gnomAD_SV"] = full["B_source"].apply(has, names=["gnomAD"])
full["long_read_catalogue"] = full["B_source"].apply(has, names=["HPRC", "CMRI"])

cols = ["AnnotSV_ID", "SV_chrom", "SV_start", "SV_end", "SV_type", "SV_length", "genes",
        "ACMG_class", "AFmax", "gnomAD_SV", "long_read_catalogue", "match", "category"]
full[cols].to_csv(sys.argv[2], sep="\t", index=False)

print(pd.crosstab(full["SV_type"], full["category"], margins=True))
