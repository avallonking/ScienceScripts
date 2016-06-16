#Program: basic statistics on samples with GATK 
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn)
#History:
#   Mon 18 April 2016 First_Release

#Variables
sample=$1
depth=$2
cd /data/home/lijiaj/operation/scripts/sci
sh gatkStat.sh $sample $depth 5 && \
sh gatkStat.sh $sample $depth 10 && \
sh gatkStat.sh $sample $depth 15 && \
sh gatkStat.sh $sample $depth 20 && \
sh gatkStat.sh $sample $depth 25 && \
sh gatkStat.sh $sample $depth 30 && \
sh gatkStat.sh $sample $depth 35 && \
sh gatkStat.sh $sample $depth 40 && \
sh gatkStat.sh $sample $depth 45 && \
sh gatkStat.sh $sample $depth 50 
