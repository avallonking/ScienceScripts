#duplicates stat for cleaned BAM file
#!/bin/sh
#module load java/1.8.0_60
for i in *.bam
do
  #name=`echo $i | cut -d . -f 1`
  #java -jar /data/home/lijiaj/software/picard-tools-1.119/MarkDuplicates.jar I=$i O=$name.remarked.bam M=$name.metics.txt ASSUME_SORTED=true
  bsub -J dupStat -n 1 -q smp -o dupStat.log '/data/home/lijiaj/software/samtools/bin/samtools view -c -f 0x400 '$i''
  bsub -J dupStat -n 1 -q smp -o dupStat.log '/data/home/lijiaj/software/samtools/bin/samtools view -c -F 0x400 '$i''
done
