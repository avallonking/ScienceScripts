#extract MAPQ from a bam
#!/bin/sh
path=`pwd`
for i in *.sam
do
  bsub -J mapqStat -q smp -n 1 -o mapqStat.log 'sh /data/home/lijiaj/operation/scripts/sub.mapqExtract.sh '$path'/'$i''
done
