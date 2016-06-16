#sample a certain faction of a BAM file
#variables
#   target: the file for sampling
#   depth: the required depth

#!/bin/sh
target=$1
depth=$2
#statfile=log_$target\_DepthOfCoverage_human.sample_summary
#statFilePath=/data/home/guoym/1-NPC_genomics_project/1-NPC_WGS_data/8-logfiles
statFile=/data/home/lijiaj/data1/guoymProject/summary.stat
bamFilePath=/data/home/guoym/1-NPC_genomics_project/1-NPC_WGS_data/3-GATK
samplePath=/data/home/lijiaj/data1/guoymProject/sample/$depth\X/$target
meanCov=`awk '$1=="'$target'"{print $14}' $statFile`
fraction=`echo "scale=4;$depth/$meanCov"|bc`

mkdir -p $samplePath
for (( seed = 1; seed < 51; seed++ )); do
  parameter=`echo "$seed+$fraction" | bc`
  echo $seed start
  /data/home/lijiaj/software/samtools/bin/samtools view -bhS -s $parameter $bamFilePath/$target\_sorted_PCRremoved_realigned_recal.bam > $samplePath/$target.$depth\X.sample.$seed.bam
  echo $seed done
done
