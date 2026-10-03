# Copy to config.sh and adjust paths before running the scripts.

REF=/path/to/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna
DORADO_MODEL=/path/to/dna_r10.4.1_e8.2_400bps_hac@v4.2.0
POD5_DIR=/path/to/pod5            # one subfolder per sample
GTF=/path/to/annotation_GRCh38.gtf.gz
ANNOTSV_ANNOTATIONS=/path/to/AnnotSV_annotations
OUT=/path/to/results
THREADS=16

SAMPLES_ASD=samples_ASD.txt       # one sample ID per line (not included)
SAMPLES_NC=samples_NC.txt

SFARI_CPG_BED=resources/SFARIgenes_CpGIslands_combined.bed
SFARI_GENES_BED=resources/SFARIgenes_chr.bed
SFARI_DMR_GENES_BED=resources/SFARIgenes_chr_filtered.bed

BAM=$OUT/bam
QC=$OUT/qc
METH=$OUT/methylation
SV=$OUT/sv
