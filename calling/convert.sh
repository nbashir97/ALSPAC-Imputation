# This script converts the PLINK input files (.ped/.map) from GenomeStudio to PLINK binaries (.bed/.bim/.fam) for QC in R

export PATH=$PATH:~/bin
data=`cat ~/config.json | jq -r '.alspac_subgroups'`

plink --file ${data}/200g/data/called/pre_qc/200g_preqc \
--make-bed \
--out ${data}/200g/data/called/pre_qc/200g_preqc
