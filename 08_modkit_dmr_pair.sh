#!/usr/bin/env bash
# Differential methylation of SFARI CpG islands, pooled NC (a) vs. pooled ASD (b)
set -euo pipefail
source "$(dirname "$0")/../config.sh"

modkit dmr pair \
  -a "$METH/NC_merged.bed.gz" \
  -b "$METH/ASD_merged.bed.gz" \
  -o "$METH/dmr_NC_vs_ASD.bed" \
  --regions-bed "$SFARI_CPG_BED" \
  --ref "$REF" \
  --base C \
  --min-valid-coverage 10 \
  --threads "$THREADS" \
  --header -f
