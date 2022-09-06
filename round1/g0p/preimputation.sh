#########################
### ALSPAC IMPUTATION ###
#########################

# Script for preparing data prior to imputation
# Data must be in PLINK binary format to begin (.bed/.bim.fam)
# This script will do the following:
#       1. Convert the files from human genome build 37 to build 38
#       2. Remove SNPs which did not correctly convert builds
#       3. Create new binaries and run checks on them
#       4. Create gzipped VCF files which can be uploaded to TOPMed 

# TOPMed documentation: https://topmedimpute.readthedocs.io/en/latest/prepare-your-data.html

##############################

# Preamble

## Loading modules
module load languages/perl/5.30.0
module load languages/anaconda3/2020-3.8.5
module load apps/plink/1.90
module load apps/samtools/1.13-30

## Get paths
export PATH=$PATH:~/bin
data=`cat ~/config.json | jq -r '.alspac_subgroups'`
helpers=`cat ~/config.json | jq -r '.alspac_helpers'`

## Rename bim file so it can be identified as the original
mv ${data}/g0p/data/originals/g0p.bim ${data}/g0p/data/originals/original_g0p.bim

## Swapping 23 for X in bim file
awk -F '\t' '{ $1 = ($1 == "23" ? "X" : $1) } 1' OFS='\t' ${data}/g0p/data/originals/original_g0p.bim \
> ${data}/g0p/data/originals/g0p.bim

##############################

# Liftover from build 37 to build 38

## Count number of individuals and SNPs at baseline
plink --bfile ${data}/g0p/data/originals/g0p \
--missing \
--out ${data}/g0p/data/preimputation/log_missing
### 2,198 individuals / 507,586 variants
### 0.998758 genotyping rate / 2,019 het. haploid genotypes

## Check for any issues with mismatched sex
plink --bfile ${data}/g0p/data/originals/g0p \
--check-sex \
--out ${data}/g0p/data/preimputation/log_sex
### None identified

## Creating map file from bim file
cut -f 1-4 ${data}/g0p/data/originals/g0p.bim > \
${data}/g0p/data/preimputation/g0p.bim.map

## Executing liftover
python3 ${helpers}/liftover/liftOverPlink.py \
-e ${helpers}/liftover/liftOverExe \
-c ${helpers}/liftover/hg19ToHg38.over.chain.gz \
-m ${data}/g0p/data/preimputation/g0p.bim.map \
-o ${data}/g0p/data/preimputation/g0p_b38

##############################

# Checks and create new binaries

## Checking whether any SNPs have been dropped
wc -l ${data}/g0p/data/preimputation/g0p_b38.map
wc -l ${data}/g0p/data/preimputation/g0p.bim.map

## Identifying RSIDs that did not liftover
cut -f 4 ${data}/g0p/data/preimputation/g0p_b38.bed.unlifted | sed "/^#/d" > \
${data}/g0p/data/preimputation/excluded_snps.dat

# Creating new binaries, excluding above RSIDs
plink --bfile ${data}/g0p/data/originals/g0p \
--exclude ${data}/g0p/data/preimputation/excluded_snps.dat \
--make-bed --out ${data}/g0p/data/preimputation/g0p_b38

# Check that all liftover RSIDs are the same as the original RSIDs
wc -l ${data}/g0p/data/preimputation/g0p_b38.bim
wc -l ${data}/g0p/data/preimputation/g0p_b38.map

cut -f 2 ${data}/g0p/data/preimputation/g0p_b38.bim > \
${data}/g0p/data/preimputation/rsid1

cut -f 2 ${data}/g0p/data/preimputation/g0p_b38.map > \
${data}/g0p/data/preimputation/rsid2

DIFF = $(diff ${data}/g0p/data/preimputation/rsid1 ${data}/g0p/data/preimputation/rsid2) 
if [ "$DIFF" != "" ] 
then
    echo "ERROR - RSIDS DON'T MATCH"
fi

##############################

# Finalising PLINK binaries and running checkBims

# Replace the old g0p.bim with the newly constructed one
paste ${data}/g0p/data/preimputation/g0p_b38.bim ${data}/g0p/data/preimputation/g0p_b38.map | head

paste ${data}/g0p/data/preimputation/g0p_b38.map \
<(cut -f 5-6 ${data}/g0p/data/preimputation/g0p_b38.bim) > \
temp && mv temp ${data}/g0p/data/preimputation/g0p_b38.bim

# Identify and remove bad SNPs
# All X chromosome SNPs are automatically idenitfied as bad as they are not indexed as "chr23"
# So remove all X SNPs from the bad list before excluding them

python3 ${helpers}/liftover/rmBadLifts.py \
--map ${data}/g0p/data/preimputation/g0p_b38.map \
--out ${data}/g0p/data/preimputation/g0p_b38_good.map \
--log ${data}/g0p/data/preimputation/g0p_bad_lifted.dat

awk '$1 == "X" {next}{print}' "${data}/g0p/data/preimputation/g0p_bad_lifted.dat" > \
${data}/g0p/data/preimputation/g0p_bad_lifted_nox.dat

cut -f 2 ${data}/g0p/data/preimputation/g0p_bad_lifted_nox.dat > \
${data}/g0p/data/preimputation/bad_snps.dat

plink --bfile ${data}/g0p/data/preimputation/g0p_b38 \
--make-bed \
--exclude ${data}/g0p/data/preimputation/bad_snps.dat \
--allow-extra-chr \
--out ${data}/g0p/data/preimputation/g0p_final

# Create frequency file
plink --bfile ${data}/g0p/data/preimputation/g0p_final \
--freq \
--out ${data}/g0p/data/preimputation/g0p_freq

# Running checks on bim files
perl ${helpers}/checkbim/HRC-1000G-check-bim.pl \
-b ${data}/g0p/data/preimputation/g0p_final.bim \
-f ${data}/g0p/data/preimputation/g0p_freq.frq \
-r ${helpers}/reference/PASS.Variants.TOPMed_freeze5_hg38_dbSNP.tab.gz \
-h -o ${data}/g0p/data/preimputation/checks

##############################

# Creating and checking gzipped VCFs for TOPMed

## Creating VCF files
sh ${data}/g0p/data/preimputation/checks/Run-plink.sh

## Renaming chromosome column to TOPMed format
for i in {1..23}
do
awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' ${data}/g0p/data/preimputation/checks/g0p_final-updated-chr$i.vcf > \
${data}/g0p/data/preimputation/checks/g0p_chr$i.vcf
done

## Compressing VCF files into .vcf.gz format
for i in {1..23}
do
bgzip ${data}/g0p/data/preimputation/checks/g0p_chr$i.vcf
done

# Moving compressed files to separate folder
for i in {1..23}
do
mv ${data}/g0p/data/preimputation/checks/g0p_chr$i.vcf.gz \
${data}/g0p/data/preimputation/final/
done

# Deleting unzipped VCFs, as they take up a lot of memory
for i in {1..23}
do
rm ${data}/g0p/data/preimputation/checks/g0p_final-updated-chr$i.vcf
rm ${data}/g0p/data/preimputation/checks/g0p_chr$i.vcf
done

# Viewing gzipped VCF
zcat ${data}/g0p/data/preimputation/final/g0p_chr1.vcf.gz | cut -f-20 | head -n 20

# Running VCF check
# VCF check is written in Python v2 and will throw up an error if you use Python v3
for i in {1..23}
do
python2 ${helpers}/vcfcheck/checkVCF.py \
-r ${helpers}/vcfcheck/hg38.fa \
-o ${data}/g0p/data/preimputation/final/checks \
${data}/g0p/data/preimputation/final/g0p_chr$i.vcf.gz
done

# VCF check will give MismatchError for a whole load of SNPs, these are not true errors
# They are an issue with the case (capital vs lower case) of the SNPs in the reference file
# Additional checks on the loci that had erros revealed the case mismacth
# In the VCF files, everything is coded in upper case (A/C/T/G), but in the reference fasta file it is upper or lower
# The TOPMed imputation server does not use the lower case coding, so the files are suitable for upload

##############################
