The manifest and cluster files could not be uploaded due to size. They can both be downloaded from directly from the [Illumina site][gsa]. Ensure that they are the GSA v1.0 files and the GRCh38 (human genome build 38) versions as this will avoid the need for liftover from build 37 to build 38 at the next stage. The manifest file is required in .bpm format (not .csv format) for compatibility with GenomeStudio.

Manifest file was then renamed to: `gsa-24-v1-manifest.bpm`

Cluster file was then renamed to: `gsa-24-v1-manifest.egt`

[gsa]: https://emea.support.illumina.com/array/array_kits/infinium-global-screening-array/downloads.html
