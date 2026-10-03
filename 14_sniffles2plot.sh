#!/usr/bin/env bash
# SV summary plots (sniffles2plot v0.2.0); ASD_unique_SFARI = Figure 2
set -euo pipefail
source "$(dirname "$0")/../config.sh"

for V in ASD_SFARI NC_SFARI ASD_unique_SFARI; do
  python3 -m sniffles2_plot -i "$SV/${V}.vcf" -o "$SV/plots_$V"
done
