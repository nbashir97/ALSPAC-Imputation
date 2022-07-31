# Variant Calling

Intensity files with uncalled genotype data on the Illumina Infinium GSA v1.0 were provided for the "200G_3" cohort. The genotypes were called and an initial round of QC done in GenomeStudio and then a second round of QC was done in R.

This folder contains the following files:
* **info.md**: This is a markdown file containing details for how the variant calling and QC was done within GenomeStudio. GenomeStudio does not use a CLI, so I have ensured the details provided are sufficient to reproduce the results from the GUI.
* /helpers: This folder contains the mainfest and cluster files corresponding to the Illumina Infinium GSA v1.0, required in order to carry out the steps in **info.md**.
* **plinkqc.R**: This is R script for executing the second round of QC following completion of the steps outlined in **info.md**. This is done through the R package *plinkqc*, which calls PLINK 1.9 under the hood.
* **postqc.sh**: This is shell script for checking the number of individuals and variants after all of the QC steps have been done as outlined above. The newly created PLINK binaries are then moved into another folder before beginning the pre-imputation data preparation.