# Helpers

This folder contain the helper files which were used throughout the project:
* `/checkbim`: Contains the files for checking the PLINK binaries and comparing to the TOPMed hg38 reference panel prior to conversion to VCFs. Version 4.2.7 of the check-bim Perl script was used, available from the Oxford [McCarthy Group Tools][McCarthy].
* `/liftover`: Contains the files for lifting over the PLINK files from build 37 to build 38. The liftOverPlink.py and rmBadLifts.py scripts are available from UCSC as part of their [Genome Browser][Browser], from their [GitHub repository][Liftover]. Also contains the chain file so the scripts know how to convert between builds, which are also available from [UCSC][Chain] for a number of different builds.
* `/reference: Contains the files for creating the TOPMed reference panels in an HRC format to check VCFs are correctly formatted prior to imputation.
* `/vcfcheck`: Contains the files for checking the VCFs are in build38 format prior to uploading to TOPMed.

The following files are not included within the subfolders due to file size restrictions:
* `/checkbim`: All files included.
* `/liftover`: The liftover executable file is not included. This must be created from the Python script.
* `/reference`: The TOPMed reference panel is not included. It needs to be created from the VCF of dbSNP submitted sites (currently ALL.TOPMed_freeze5_hg38_dbSNP.vcf.gz). This can be downloaded from the [Bravo Website][Bravo]. Once downloaded, the VCF can be converted to an HRC formatted reference legen using the CreateTOPMed.pl script available from the [McCarthy Group][McCarthy]. The file output by this is also not included in the `/reference` folder. This was named PASS.Variants.TOPMed_freeze5_hg38_dbSNP.tab.
* `/vcfcheck`: The hg38 fasta file itself is not included, but the fasta index file created from Samtools is. The build 38 fasta file is available from the [NIH][NIH] website.

Further details on recommended preprocessing steps can be found at the [TOPMed data preparation site][TOPMed].

[McCarthy]: https://www.well.ox.ac.uk/~wrayner/tools/
[Browser]: http://genome.ucsc.edu/
[Liftover]: https://github.com/sritchie73/liftOverPlink
[Chain]: https://hgdownload.soe.ucsc.edu/gbdb/hg19/liftOver/
[Bravo]: https://bravo.sph.umich.edu/freeze5/hg38/
[NIH]: https://www.ncbi.nlm.nih.gov/assembly/GCF_000001405.26/
[TOPMed]: https://topmedimpute.readthedocs.io/en/latest/prepare-your-data.html
