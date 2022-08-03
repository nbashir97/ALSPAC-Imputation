# GenomeStudio Variant Calling & QC

Provided were the intensity files containing results from genotyping, using the [Illumina Iffinium Global Screening Array v1.0][gsa]. Using the appropriate [manifest][files] and [cluster][files] files for the array, the genotypes were called and QCd. This was done in accordance with the [technical recommendations][guide] provided by Illumina for human studies. 

Note: Illumina's statistical methods for clustering are done by mapping from Cartesian to polar coordinates, as visualization of (normalized) r and theta is easier than (x,y). It is on this normalised polar coordinate scale that the SNP quality metrics are measured.

A quick reference to read up on Illumina's terminology for naming strands: https://www.biostars.org/p/4885/

## QC Cut-offs

Illumina provides two options when QCing called genotype data; hard cut-offs and gray zone cut-offs. These are individual- and loci-specific metrics which determine whether to retain or exclude samples/variants. The hard cut-offs are points at which samples/variants should definitely be excluded and the gray zone cut-offs are points up to which there may or may not be calls of reasonable quality. Since the aim of this work was to unify and impute separate batches, the strictest cut-off criteria were used in order to retain only high-quality samples/variants.

## Steps

GenomeStudio is run from a GUI so there is no CLI script to provide, just the following set of instructions to reproduce the variant calling and QC:

Creating project:
* Import files: alspac_idats (raw intensity files), gsa-24-v1-manifest.bpm (GSA v1.0 manifest file), gsa-24-v1-manifest.egt (GSA v1.0 cluster file).
* Samples (_n_) = 2,979
* Loci (_n_) = 618,540

Filtering by sample quality (call rate)
* Calculate call rates
* In samples table: Filter=[(“Call Rate”)>=0.99]
* Samples (_n_) = 2,868 (111 excluded)

Filtering by cluster separation (angle of cluster separation in polar coordinates)
* Update SNP statistics
* SNP table: Filter=[(“gsa-24-v1-manifest.bpm.Cluster Sep”>=0.45)]
* Loci (_n_) = 608,979 (9,561 excluded)

Filtering by call frequency
* Update SNP statistics
* SNP table: Filter=[("gsa-24-v1-manifest.bpm.Cluster Sep">=0.45) AND ("Call Freq">0.99)]
* Loci (_n_) = 559,619 (additional 49,360 excluded)

Filtering by normalised intensity (cluster radius from origin in polar coordinates)
* Update SNP statistics
* SNP table: Filter=[("gsa-24-v1-manifest.bpm.Cluster Sep">=0.45) AND ("Call Freq">0.99) AND [("gsa-24-v1-manifest.bpm.AB R Mean">0.4)]
* Loci (_n_) = 558,237 (additional 1,382 excluded)

Filtering by normalised theta (cluster degrees from origin in polar coordinates)
* Update SNP statistics
* SNP table: Filter=[("gsa-24-v1-manifest.bpm.Cluster Sep">=0.45) AND ("Call Freq">0.99) AND [("gsa-24-v1-manifest.bpm.AB R Mean">0.4) AND [("gsa-24-v1-manifest.bpm.AB T Mean">=0.2) AND ("gsa-24-v1-manifest.bpm.AB T Mean"<=0.8)]
* Loci (_n_) = 557,886 (additional 351 excluded)

Filtering by reproducibility errors
* Update SNP statistics
* SNP table: Filter=[("gsa-24-v1-manifest.bpm.Cluster Sep">=0.45) AND ("Call Freq">0.99) AND [("gsa-24-v1-manifest.bpm.AB R Mean">0.4) AND [("gsa-24-v1-manifest.bpm.AB T Mean">=0.2) AND ("gsa-24-v1-manifest.bpm.AB T Mean"<=0.8) AND ("Rep Errors">0)]
* Loci (_n_) = 557,886 (additional 0 excluded)

Filtering by excess heterozygote calls (HWE)
* Update SNP statistics
* SNP table: Filter=[("gsa-24-v1-manifest.bpm.Cluster Sep">=0.45) AND ("Call Freq">0.99) AND [("gsa-24-v1-manifest.bpm.AB R Mean">0.4) AND [("gsa-24-v1-manifest.bpm.AB T Mean">=0.2) AND ("gsa-24-v1-manifest.bpm.AB T Mean"<=0.8) AND ("Rep Errors">0) AND ("Het Excess"<=0.2)]
* Loci (_n_) = 557,865 (additional 21 excluded)

After QC:
* Samples (_n_) = 2,868 (111 out of 2,979 excluded)
* Loci (_n_) = 557,865 (60,675 out of 618,540 excluded)

Exported as PLINK input files (200g.ped/200g.map)

[files]: https://emea.support.illumina.com/downloads/infinium-global-screening-array-v1-0-product-files.html
[gsa]: https://emea.illumina.com/products/by-type/microarray-kits/infinium-global-screening.html
[guide]: https://www.illumina.com/Documents/products/technotes/technote_infinium_genotyping_data_analysis.pdf
