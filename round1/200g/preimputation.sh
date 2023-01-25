#########################
### ALSPAC IMPUTATION ###
#########################

# Script for preparing data prior to imputation
# Data must be in PLINK binary format to begin (.bed/.bim.fam)
# This script will do the following:
#       1. Check binaries
#       2. Create gzipped VCF files which can be uploaded to TOPMed 

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

##############################

# Count number of individuals and SNPs at baseline
plink --bfile ${data}/200g/data/called/post_qc/200g \
--missing \
--out ${data}/200g/data/preimputation/log_missing
### 2,780 individuals / 461,353 variants
### 0.999116 genotyping rate / het. haploid genotypes not reported

# Check for any issues with mismatched sex
plink --bfile ${data}/200g/data/called/post_qc/200g \
--check-sex \
--out ${data}/200g/data/preimputation/log_sex
### No sex phenotypes available

##############################

# Running checkBims

# Create frequency file
plink --bfile ${data}/200g/data/called/post_qc/200g \
--freq \
--out ${data}/200g/data/preimputation/200g_freq

# Running checks on bim files
perl ${helpers}/checkbim/HRC-1000G-check-bim.pl \
-b ${data}/200g/data/called/post_qc/200g.bim \
-f ${data}/200g/data/preimputation/200g_freq.frq \
-r ${helpers}/reference/PASS.Variants.TOPMed_freeze5_hg38_dbSNP.tab.gz \
-h -o ${data}/200g/data/preimputation/checks

##############################

# Creating and checking gzipped VCFs for TOPMed

## Creating VCF files
sh ${data}/200g/data/preimputation/checks/Run-plink.sh

## Renaming chromosome column to TOPMed format
for i in {1..23}
do
awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' ${data}/200g/data/preimputation/checks/200g-updated-chr$i.vcf > \
${data}/200g/data/preimputation/checks/200g_chr$i.vcf
done

## Compressing VCF files into .vcf.gz format
for i in {1..23}
do
bgzip ${data}/200g/data/preimputation/checks/200g_chr$i.vcf
done

# Moving compressed files to separate folder
for i in {1..23}
do
mv ${data}/200g/data/preimputation/checks/200g_chr$i.vcf.gz \
${data}/200g/data/preimputation/final/
done

# Deleting unzipped VCFs, as they take up a lot of memory
for i in {1..23}
do
rm ${data}/200g/data/preimputation/checks/200g-updated-chr$i.vcf
rm ${data}/200g/data/preimputation/checks/200g_chr$i.vcf
done

# Viewing gzipped VCF
zcat ${data}/200g/data/preimputation/final/200g_chr1.vcf.gz | cut -f-20 | head -n 20

# Running VCF check
# VCF check is written in Python v2 and will throw up an error if you use Python v3
for i in {1..23}
do
python2 ${helpers}/vcfcheck/checkVCF.py \
-r ${helpers}/vcfcheck/hg38.fa \
-o ${data}/200g/data/preimputation/final/checks \
${data}/200g/data/preimputation/final/200g_chr$i.vcf.gz
done

# VCF check will give MismatchError for a whole load of SNPs, these are not true errors
# They are an issue with the case (capital vs lower case) of the SNPs in the reference file
# Additional checks on the loci that had erros revealed the case mismacth
# In the VCF files, everything is coded in upper case (A/C/T/G), but in the reference fasta file it is upper or lower
# The TOPMed imputation server does not use the lower case coding, so the files are suitable for upload

##############################
