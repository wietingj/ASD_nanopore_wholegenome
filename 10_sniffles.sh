#!/usr/bin/env bash
# SV calling per sample (Sniffles2 v2.4)
set -euo pipefail
source "$(dirname "$0")/../config.sh"
mkdir -p "$SV/sniffles"

mapfile -t SAMPLES < <(cat "$SAMPLES_ASD" "$SAMPLES_NC")
for S in "${SAMPLES[@]}"; do
  sniffles --input "$BAM/${S}.bam" --reference "$REF" \
    --vcf "$SV/sniffles/${S}.vcf" --snf "$SV/sniffles/${S}.snf" \
    --threads "$THREADS"
done
