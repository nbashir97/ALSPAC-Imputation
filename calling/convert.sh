# This script converts the PLINK text files (.ped/.map) output by GenomeStudio into PLINK binaries (.bed/.bim/.fam) for QC in R

export PATH=$PATH:~/bin
data=`cat ~/config.json | jq -r '.alspac_subgroups'`

plink --file ${data}/200g/data/called/pre_qc/200g \
--make-bed \
--out ${data}/200g/data/called/pre_qc/200g
