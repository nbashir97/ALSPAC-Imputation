# ALSPAC Imputation

This repository contains the scripts used to unify and impute geontypes for three subgroups within the [Avon Longitudinal Study of Parents and Children (ALSPAC)][alspac] to the NIH [Trans-Omics for Precision Medicine (TOPMed)][topmed] reference panel.

## Prerequisites

This work was carried out within [BlueCrystal Phase 4][bc4] high performance computing cluster at the University of Bristol. The following software is required (minimum versions): [GenomeStudio][genomestudio] 2.0, [Perl][perl] 5.30.0, [Python][python] 3.8.5 (ideally an [Anaconda][anaconda] distribution as this will have preinstalled the necessary libraries), [PLINK][plink] 1.9, [R][r] 4.1.0, [samtools][samtools] 1.13.

## Details

The three original subgroups from within ALSPAC who were unified into a single imputed dataset were:

* **gwa_660_g0m** (PLINK binaries): A batch of approximately 18,000 mothers and children ("Duos").
* **gwa_exome_g0p** (PLINK binaries): A second batch of approximately 2,220 mothers and fathers.
* **200G_3** (.idat files): A batch of approximately 3,000 of the most recent individuals for whom there was genotype data available, in uncalled intensity files.

## Variant Calling

For the the individuals within "200G_3", the data was in the .idat intensity files and the variants had to be called. The calling and first round of QC was done within GenomeStudio and then a second round of QC was done within R. Further details of this are within the /calling directory.

## Imputation Round 1

Once PLINK binaries were available for the datasets, they were checked, prepared, and formatted to make them suitable for upload to the NIH server. This was done in line with the [recommendations][topmed_doc] from the TOPMed developers at University of Michigan. Further details of this are within the /round1 directory.

## Checks

## Imputation Round 2

## Checks

[alspac]: http://www.bristol.ac.uk/alspac/
[anaconda]: https://www.anaconda.com/
[bc4]: https://www.acrc.bris.ac.uk/acrc/phase4.htm
[genomestudio]: https://emea.support.illumina.com/array/array_software/genomestudio/downloads.html
[perl]: https://www.perl.org/
[python]: https://www.python.org/
[plink]: https://www.cog-genomics.org/plink/
[r]: https://cran.r-project.org/bin/windows/base/
[samtools]: http://www.htslib.org/
[topmed]: https://imputation.biodatacatalyst.nhlbi.nih.gov/
[topmed_doc]: https://topmedimpute.readthedocs.io/en/latest/