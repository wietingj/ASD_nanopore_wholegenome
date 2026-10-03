#!/usr/bin/env bash
# Merge modBAMs per group (ASD_merged.bam, NC_merged.bam)
set -euo pipefail
source "$(dirname "$0")/../config.sh"

for G in ASD NC; do
  LIST=SAMPLES_$G
  samtools merge -f -@ "$THREADS" -o "$BAM/${G}_merged.bam" \
    $(sed "s|.*|$BAM/&.bam|" "${!LIST}")
  samtools index "$BAM/${G}_merged.bam"
done
