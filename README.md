# ALSPAC Imputation

This repository contains the scripts used to unify and impute genotypes for the three main subgroups within the [Avon Longitudinal Study of Parents and Children (ALSPAC)][alspac] to the NIH [Trans-Omics for Precision Medicine (TOPMed)][topmed] reference panel.

## Prerequisites

This work was carried out within [BlueCrystal Phase 4][bc4] high performance computing cluster at the University of Bristol. The following software is required (minimum versions): [GenomeStudio 2.0][genomestudio], [Perl 5.30.0][perl], [Python 3.8.5][python] (ideally an [Anaconda][anaconda] distribution as this will have preinstalled the necessary libraries) AND a version 2.x of [Python][python] as one of the helper scripts has not been refactored to version 3, [PLINK 1.9][plink], [R 4.1.0][r], [samtools 1.13][samtools].

## Details

The three original subgroups from within ALSPAC who were unified into a single imputed dataset were:

* `gwa_660_g0m` (PLINK binaries): A batch of approximately 18,000 mothers and children ("duos").
* `gwa_exome_g0p` (PLINK binaries): A second batch of approximately 2,220 mothers and fathers.
* `200G_3` (.idat files): A batch of approximately 3,000 of the most recent individuals for whom there was genotype data available, in uncalled intensity files.

The `config.json` contains paths to the appropriate directories and is user-specific. It should be stored in your home directory.

## Variant Calling

For the the individuals within `200G_3`, the data was in **.idat** intensity files and the variants had to be called. The calling and first round of QC was done within GenomeStudio and then a second round of QC was done within `R`. Further details of this stage are within the [/calling][calling] directory.

## Imputation Round 1

Once PLINK binaries were available for the datasets, they were checked, prepared, and formatted to make them suitable for upload to the NIH server. This was done in line with the [recommendations][topmed_doc] from the TOPMed developers at University of Michigan. Further details of this stage are within the [/round1][round1] directory.

## Checks

## Imputation Round 2

## Checks

[alspac]: http://www.bristol.ac.uk/alspac/
[anaconda]: https://www.anaconda.com/
[bc4]: https://www.acrc.bris.ac.uk/acrc/phase4.htm
[calling]: https://github.com/nbashir97/alspac_imputation/tree/main/calling
[genomestudio]: https://emea.support.illumina.com/array/array_software/genomestudio/downloads.html
[perl]: https://www.perl.org/
[python]: https://www.python.org/
[plink]: https://www.cog-genomics.org/plink/
[r]: https://cran.r-project.org/bin/windows/base/
[round1]: https://github.com/nbashir97/alspac_imputation/tree/main/round1
[samtools]: http://www.htslib.org/
[topmed]: https://imputation.biodatacatalyst.nhlbi.nih.gov/
[topmed_doc]: https://topmedimpute.readthedocs.io/en/latest/
