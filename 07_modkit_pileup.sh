#!/usr/bin/env bash
# modBAM -> bedMethyl (modkit v0.3.1), per sample and per merged group
set -euo pipefail
source "$(dirname "$0")/../config.sh"
mkdir -p "$METH"

pileup () {
  modkit pileup "$BAM/$1.bam" "$METH/$1.bed" --cpg --ref "$REF" --threads "$THREADS"
  bgzip -f "$METH/$1.bed"
  tabix -f -p bed "$METH/$1.bed.gz"
}

mapfile -t SAMPLES < <(cat "$SAMPLES_ASD" "$SAMPLES_NC")
for S in "${SAMPLES[@]}"; do pileup "$S"; done
for G in ASD NC; do pileup "${G}_merged"; done
