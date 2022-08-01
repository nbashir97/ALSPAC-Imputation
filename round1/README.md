# Pre-imputation Preparation

This folder contains the script used to prepare the `PLINK` binaries for upload to the TOPMed server as gzipped VCF files. This was done in line with the [TOPMed recommendations][topmed_doc]. The scripts in [/g0m][g0m] and [/g0p][g0p] are essentially identical, except for changes to the directory where the files are located. The script in [/200g][200g] does not involve conversion from build 37 to build 38, as I called the variants from the intensity files directly into build 38.

Further details of the imputation itself are in `imputation_details.md`.

[200g]: https://github.com/nbashir97/alspac_imputation/tree/main/round1/g200g
[g0m]: https://github.com/nbashir97/alspac_imputation/tree/main/round1/g0m
[g0p]: https://github.com/nbashir97/alspac_imputation/tree/main/round1/g0p
[topmed_doc]: https://topmedimpute.readthedocs.io/en/latest/
