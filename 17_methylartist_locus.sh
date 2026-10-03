#!/usr/bin/env bash
# Locus plots of selected CpG islands, pooled ASD vs. NC (methylartist; Figure 1)
# Usage: 17_methylartist_locus.sh chr:start-end [highlight_start-highlight_end]
set -euo pipefail
source "$(dirname "$0")/../config.sh"
mkdir -p "$OUT/figures"

REGION=$1
methylartist locus \
  -b "$BAM/ASD_merged.bam,$BAM/NC_merged.bam" \
  -i "$REGION" \
  -g "$GTF" \
  --ref "$REF" \
  --motif CG \
  ${2:+-l "$2"} \
  --outfile "$OUT/figures/locus_${REGION//[:-]/_}.png"
