#!/usr/bin/env bash
# Basecalling, 5mCG/5hmCG calling and alignment (dorado v0.5.3)
set -euo pipefail
source "$(dirname "$0")/../config.sh"
mkdir -p "$BAM"

mapfile -t SAMPLES < <(cat "$SAMPLES_ASD" "$SAMPLES_NC")
for S in "${SAMPLES[@]}"; do
  dorado basecaller "$DORADO_MODEL" "$POD5_DIR/$S" \
    --modified-bases 5mCG_5hmCG \
    --reference "$REF" \
    > "$BAM/${S}.unsorted.bam"
done
