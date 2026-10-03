#!/usr/bin/env bash
# Sort and index modBAMs
set -euo pipefail
source "$(dirname "$0")/../config.sh"

mapfile -t SAMPLES < <(cat "$SAMPLES_ASD" "$SAMPLES_NC")
for S in "${SAMPLES[@]}"; do
  samtools sort -@ "$THREADS" -o "$BAM/${S}.bam" "$BAM/${S}.unsorted.bam"
  samtools index "$BAM/${S}.bam"
done
