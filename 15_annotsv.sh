#!/usr/bin/env bash
# Annotation and ACMG/ClinGen classification of ASD-unique SVs (AnnotSV)
set -euo pipefail
source "$(dirname "$0")/../config.sh"

for V in ASD_unique_SFARI ASD_unique_SFARI_DMRgenes; do
  AnnotSV -SVinputFile "$SV/${V}.vcf" \
    -annotationsDir "$ANNOTSV_ANNOTATIONS" \
    -outputDir "$SV/annotsv" \
    -outputFile "AnnotSV_${V}" \
    -genomeBuild GRCh38 \
    -includeCI 1 \
    -metrics us
done
