#!/usr/bin/env bash
# SV merging within one group (Jasmine v1.1.4, Iris v1.0.4), following
# https://github.com/mkirsche/Jasmine/tree/master/pipeline
# Usage: 11_jasmine.sh NC    |    11_jasmine.sh ASD 10
set -euo pipefail
source "$(dirname "$0")/../config.sh"

G=$1
MIN_SUPPORT=${2:-1}
LIST=SAMPLES_$G
W="$SV/jasmine_$G"
mkdir -p "$W"/{step3,step4,step5,step6,step7}
sed "s|.*|$SV/sniffles/&.vcf|" "${!LIST}" > "$W/filelist_$G.txt"

# Step 3: convert duplications to insertions
jasmine --dup_to_ins --preprocess_only --file_list="$W/filelist_$G.txt" --out_dir="$W/step3" \
  --threads="$THREADS" --genome_file="$REF"

# Step 4: refine SVs with Iris
mapfile -t VCFS < "$W/step3/filelist_${G}_dupToIns.txt"
for VCF in "${VCFS[@]}"; do
  NAME=$(basename "$VCF" .vcf)
  iris genome_in="$REF" vcf_in="$VCF" reads_in="$BAM/${NAME}.bam" \
    vcf_out="$W/step4/${NAME}_refined.vcf" threads="$THREADS"
done
ls "$W"/step4/*_refined.vcf > "$W/step4/refined_vcfs.txt"

# Step 5: normalize SV types
jasmine --preprocess_only --pre_normalize --file_list="$W/step4/refined_vcfs.txt" \
  --out_dir="$W/step5" --threads="$THREADS"
ls "$W"/step5/*.vcf > "$W/step5/normalized_vcfs.txt"

# Step 6: mark high-confidence calls
jasmine --preprocess_only --mark_specific --spec_reads=10 --spec_len=30 \
  --file_list="$W/step5/normalized_vcfs.txt" --out_dir="$W/step6" --threads="$THREADS"
ls "$W"/step6/*.vcf > "$W/step6/specific_vcfs.txt"

# Step 7: remove duplicate calls (output not used in step 9)
jasmine --allow_intrasample --nonlinear_dist --max_dist=200 \
  --file_list="$W/step6/specific_vcfs.txt" --out_file="$W/step7/deduped_samples.vcf" --threads="$THREADS"

# Step 9: merge SVs across samples (ASD: --min_support=10, i.e. called in all ASD samples)
jasmine --file_list="$W/step6/specific_vcfs.txt" --out_file="$SV/${G}_merged.vcf" \
  --threads="$THREADS" --min_support="$MIN_SUPPORT"

# Step 10: convert insertions back to duplications
jasmine --dup_to_ins --postprocess_only --out_file="$SV/${G}_merged.vcf" \
  --threads="$THREADS" --genome_file="$REF"

# Step 11: remove low-confidence calls (separate file, not used downstream)
grep -v 'IMPRECISE;' "$SV/${G}_merged.vcf" | grep -v 'IS_SPECIFIC=0' > "$SV/${G}_merged_highconf.vcf"
