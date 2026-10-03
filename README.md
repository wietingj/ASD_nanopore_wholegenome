# ASD-nanopore-SFARI

Analysis scripts for:

> Wieting J, et al. *Long-Read Nanopore Sequencing of Autism Susceptibility Genes: An Exploratory Study in Adults with Autism Spectrum Disorder.* (under review)

Whole-genome nanopore sequencing (ONT R10.4.1, PromethION) of 10 adults with ASD and 10 neurotypical controls (NC). The scripts cover basecalling, quality control, differential methylation of CpG islands of SFARI autism susceptibility genes and structural variant (SV) analysis as described in the Methods section of the manuscript.

## Data availability

No participant-level data are included in this repository. Raw sequencing data are available via controlled access from the European Genome-phenome Archive (EGA), dataset EGAD50000002495.

## Setup

1. Copy `config.example.sh` to `config.sh` and set the paths.
2. Create `samples_ASD.txt` and `samples_NC.txt` (one sample ID per line; not included).
3. Region files are in `resources/` (see `resources/README.md`).
4. Run the scripts in numerical order from the repository root, e.g. `bash scripts/01_basecalling.sh`.

## Workflow

| Script | Step |
|---|---|
| `01_basecalling.sh` | Basecalling, 5mCG/5hmCG calling and alignment to GRCh38 (dorado) |
| `02_sort_index.sh` | Sorting and indexing of modBAMs (samtools) |
| `03_qc.sh` | Coverage (mosdepth) and alignment statistics (cramino) |
| `04_collect_qc.py` | QC summary table of all samples |
| `05_group_statistics.R` | Descriptive statistics and t-tests by group (demographics, coverage) |
| `06_merge_groups.sh` | Group-wise merging of modBAMs (ASD_merged, NC_merged) |
| `07_modkit_pileup.sh` | bedMethyl files per sample and per group (modkit pileup --cpg) |
| `08_modkit_dmr_pair.sh` | Differential methylation of SFARI CpG islands, pooled NC vs. pooled ASD |
| `09_dmr_select.py` | Selection of potential DMRs (top 5 % LRS, \|delta\| >= 0.05) and SFARI genes containing them |
| `10_sniffles.sh` | SV calling per sample (Sniffles2) |
| `11_jasmine.sh` | SV merging within groups (Jasmine/Iris; `11_jasmine.sh NC`, `11_jasmine.sh ASD 10`) |
| `12_sfari_filter_isec.sh` | SFARI gene regions (bcftools view -T), ASD-unique SVs (bcftools isec -C), ASD-unique SVs in genes with potential DMRs |
| `13_sv_type_counts.py` | SV counts by type, ASD vs. NC |
| `14_sniffles2plot.sh` | SV summary plots (Figure 2) |
| `15_annotsv.sh` | SV annotation and ACMG/ClinGen classification (AnnotSV) |
| `16_population_comparison.py` | Comparison with catalogued benign SVs (gnomAD-SV, HPRC) |
| `17_methylartist_locus.sh` | Methylation locus plots (Figure 1) |

## Software

| Tool | Version |
|---|---|
| dorado | 0.5.3 (model dna_r10.4.1_e8.2_400bps_hac@v4.2.0) |
| samtools / bcftools / htslib | 1.21 |
| mosdepth | 0.3.2 |
| cramino | 0.14.5 |
| modkit | 0.3.1 |
| Sniffles2 | 2.4 |
| Jasmine / Iris | 1.1.4 / 1.0.4 |
| sniffles2plot | 0.2.0 |
| AnnotSV | 3.4.4 |
| methylartist | 1.3.1 |
| Python 3 (pandas, numpy, matplotlib) | 3.13 (scripts 04, 13); 3.11 with pandas 3.0.2 (scripts 09, 16) |
| R (dplyr, openxlsx) | 4.4.2 (dplyr 1.1.4, openxlsx 4.2.7.1) |

Reference: GRCh38 (GenBank GCA_000001405.15, no-alt analysis set).
