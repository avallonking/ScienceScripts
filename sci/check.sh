#call variants for indel checking
#!/bin/sh

#Constant
#sentieon truth set
senTruth=/data/home/lijiaj/data/guoymProject/analysis/truth_sentieon
#gatk truth set
gatkTruth=/data/home/lijiaj/data/guoymProject/analysis/truth_gatk
sampleDir=/data/home/lijiaj/data/guoymProject/analysis
resultDir=/data/home/lijiaj/data/guoymProject/analysis/result

#Variables
depth=$1

#Main
module load java/1.8.0_60
for i in $sampleDir/$depth\X/*
do
  test -d $i || continue
  sample=`echo $i | rev | cut -d / -f 1 | rev`
  mkdir -p $resultDir/$depth\X/$sample/gatk
  mkdir -p $resultDir/$depth\X/$sample/sentieon
  for (( t = 1; t < 51; t++ )); 
  do
    #EBV
    java -jar /data/home/lijiaj/software/picard-tools-2.2.1/picard.jar GenotypeConcordance CALL_VCF=$i/$t/genotyped.$sample.$t.EBV.vcf CALL_SAMPLE=$sample TRUTH_VCF=$gatkTruth/$sample.EBV.vcf TRUTH_SAMPLE=$sample O=$resultDir/$depth\X/$sample/gatk/$t.gatk.EBV
    java -jar /data/home/lijiaj/software/picard-tools-2.2.1/picard.jar GenotypeConcordance CALL_VCF=$i/$t/genotyped.$sample.$t.EBV.vcf CALL_SAMPLE=$sample TRUTH_VCF=$senTruth/$sample.EBV.vcf TRUTH_SAMPLE=$sample O=$resultDir/$depth\X/$sample/sentieon/$t.sentieon.EBV
    #human
    java -jar /data/home/lijiaj/software/picard-tools-2.2.1/picard.jar GenotypeConcordance CALL_VCF=$i/$t/genotyped.$sample.$t.human.vcf CALL_SAMPLE=$sample TRUTH_VCF=$gatkTruth/$sample.human.vcf TRUTH_SAMPLE=$sample O=$resultDir/$depth\X/$sample/gatk/$t.gatk.human
    java -jar /data/home/lijiaj/software/picard-tools-2.2.1/picard.jar GenotypeConcordance CALL_VCF=$i/$t/genotyped.$sample.$t.human.vcf CALL_SAMPLE=$sample TRUTH_VCF=$senTruth/$sample.human.vcf TRUTH_SAMPLE=$sample O=$resultDir/$depth\X/$sample/sentieon/$t.sentieon.human
  done
done
