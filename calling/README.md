# Variant Calling

Intensity files with uncalled genotype data on the Illumina Infinium GSA v1.0 were provided for the `200G_3` cohort. The genotypes were called and an initial round of QC done in `GenomeStudio`, and then a second round of QC was done in `R`.

This folder contains the following files:
* `info.md`: This is a markdown file containing details for how the variant calling and QC was done within [GenomeStudio 2.0][genomestudio]. GenomeStudio does not use a CLI, so I have ensured the details provided are sufficient to reproduce the results from the GUI.
* `/helpers`: This folder contains the mainfest and cluster files corresponding to the [Illumina Infinium GSA v1.0][gsa], required in order to carry out the steps in [`info.md`][info].
* `convert.sh`: This converts the output from `GenomeStudio` (.ped/.map) into `PLINK` binaries (.bed/.bim/.fam) for the second round of QC in `R`.
* `plinkqc.R`: This is `R` script for executing the second round of QC following completion of the steps outlined in **info.md**. This is done through the `R` package [`plinkqc`][plinkqc], which calls [`PLINK` 1.9][plink] under the hood.

[genomestudio]: https://emea.support.illumina.com/array/array_software/genomestudio/downloads.html
[gsa]: https://emea.support.illumina.com/array/array_kits/infinium-global-screening-array/downloads.html
[info]: https://github.com/nbashir97/alspac_imputation/blob/main/calling/info.md
[plink]: https://www.cog-genomics.org/plink/
[plinkqc]: https://meyer-lab-cshl.github.io/plinkQC/articles/plinkQC.html
