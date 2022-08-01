###########################
### QC Called Genotypes ###
###########################

# This script will carry out QC on the called genotypes which were output from GenomeStudio.
# It requires the package "plinkQC", which will call PLINK 1.9 on the backend.
# It also requires the PLINK input files from GenomeStudio, converted to binaries. 

# Loading plinkQC
library(plinkQC)

# Specifying variables
## indir should specify the path to the PLINK binaries which require QC
## qcdir shoudl specify the path to where the QCd output should be stored
## name should specify the name of the PLINK binaries which require QC
## path2plink should specfiy the directory where PLINK 1.9 is stored
package.dir <- find.package("plinkQC")
indir <- file.path("{Insert path to PLINK binaries}")
qcdir <- file.path("{Insert path to where QC output should be stored}")
name <- "{Insert name of PLINK binaries}"
path2plink <- "{Insert path to PLINK 1.9}"

# Sample-level QC
## Reported sex for 200G not available, so did not filter by sex at this stage
## Not necessary to filter by relatedness or ancestry for the purposes of imputation
fail_individuals <- perIndividualQC(indir = indir, qcdir = qcdir, name = name,
                                    path2plink = path2plink,
                                    dont.check_sex = TRUE,
                                    dont.check_relatedness = TRUE,
                                    dont.check_ancestry = TRUE,
                                    interactive = TRUE, verbose = TRUE)

# Marker-level QC
fail_markers <- perMarkerQC(indir = indir, qcdir = qcdir, name = name,
                            path2plink = path2plink,
                            interactive = TRUE, verbose = TRUE)
                            
# It is possible to create sample- and marker-level visualisation in plinkQC, but there is no need as it is easy to see how the data was QCd in the created logs

# Creating cleaned PLINK binaries
## These will be saved as name.clean.bed / name.clean.bim / name.clean.fam in qcdir
IDs <- cleanData(indir = indir, qcdir = qcdir, name = name,
                 path2plink = path2plink,
                 filterSex = FALSE,
                 filterRelated = FALSE,
                 filterAncestry = FALSE,
                 verbose = TRUE, showPlinkOutput = FALSE)

# PLINK binaries renamed to "200g_clean"(.bed/.bim/.fam)
