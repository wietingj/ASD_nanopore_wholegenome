#!/usr/bin/env python3
"""Select potential DMRs from modkit dmr pair output (top 5 % of likelihood ratio
scores and |delta fraction modified| >= 0.05) and write the SFARI gene regions
containing them (used for the SV-DMR intersection).
Usage: 09_dmr_select.py dmr_NC_vs_ASD.bed SFARIgenes_chr.bed selected_DMRs.tsv SFARIgenes_chr_filtered.bed
"""
import sys
import pandas as pd

dmr_file, genes_file, out_dmr, out_genes = sys.argv[1:5]

d = pd.read_csv(dmr_file, sep="\t")
d.columns = [c.lstrip("#") for c in d.columns]
d["delta"] = d["b_pct_modified"] - d["a_pct_modified"]

top = d.sort_values("score", ascending=False).head(int(len(d) * 0.05))
sel = top[top["delta"].abs() >= 0.05]
sel.to_csv(out_dmr, sep="\t", index=False)

g = pd.read_csv(genes_file, sep="\t", header=None, names=["chrom", "start", "end", "gene"])
hit = g.apply(lambda r: ((sel["chrom"] == r["chrom"]) & (sel["start"] < r["end"])
                         & (sel["end"] > r["start"])).any(), axis=1)
g[hit].to_csv(out_genes, sep="\t", header=False, index=False)

print(f"regions: {len(d)}, top 5 % LRS: {len(top)} (LRS >= {top['score'].min():.3f}), "
      f"selected: {len(sel)}, genes: {hit.sum()}")
