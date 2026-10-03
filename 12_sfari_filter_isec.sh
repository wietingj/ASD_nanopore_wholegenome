#!/usr/bin/env bash
# Restrict merged SVs to SFARI gene regions, extract ASD-unique SVs and
# ASD-unique SVs in genes with potential DMRs (bcftools)
set -euo pipefail
source "$(dirname "$0")/../config.sh"

for G in ASD NC; do
  bcftools view -T "$SFARI_GENES_BED" "$SV/${G}_merged.vcf" > "$SV/${G}_SFARI.vcf"
  bcftools sort "$SV/${G}_SFARI.vcf" -Oz -o "$SV/${G}_SFARI.vcf.gz"
  bcftools index "$SV/${G}_SFARI.vcf.gz"
done

# records present in ASD but absent in NC (exact record match); 0000.vcf = ASD-unique
bcftools isec -C -p "$SV/isec" "$SV/ASD_SFARI.vcf.gz" "$SV/NC_SFARI.vcf.gz"
cp "$SV/isec/0000.vcf" "$SV/ASD_unique_SFARI.vcf"

bcftools view -T "$SFARI_DMR_GENES_BED" "$SV/ASD_unique_SFARI.vcf" > "$SV/ASD_unique_SFARI_DMRgenes.vcf"
