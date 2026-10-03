#!/usr/bin/env bash
# Coverage (mosdepth v0.3.2) and alignment statistics (cramino v0.14.5), default parameters
set -euo pipefail
source "$(dirname "$0")/../config.sh"
mkdir -p "$QC"

mapfile -t SAMPLES < <(cat "$SAMPLES_ASD" "$SAMPLES_NC")
for S in "${SAMPLES[@]}"; do
  mosdepth "$QC/$S" "$BAM/${S}.bam"
  cramino "$BAM/${S}.bam" > "$QC/${S}.cramino.txt"
done
