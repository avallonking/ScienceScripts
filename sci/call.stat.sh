#Program: call variants with sentieon + basic statistcs on samples with GATK 
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn)
#History:
#   Sat 16 April 2016 First_Release

#Variables
sample=$1
depth=$2
abbr_sample=`echo $sample | cut -d _ -f 1`
#num=$3
#Main
for (( i = 1; i < 51; i++ )); do
  cd /data/home/lijiaj/operation/scripts/sci
  #echo $i
  #test -e /data/home/lijiaj/data/guoymProject/analysis/$depth\X/$sample/$i && continue 
  #test -e /data/home/lijiaj/data/guoymProject/analysis/$depth\X/$sample/$i || 
  sh sentieon.sh $sample $depth $i
  #if (( i % 15 == 1 )); then
    #bsub -J $abbr_sample\stat$i -m "c008" -n 4 -o /data/home/lijiaj/data/guoymProject/analysis/$sample.$depth\X.stat.log 'sh gatkStat.sh '$sample' '$depth' '$i''
  #fi
done
