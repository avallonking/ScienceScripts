#convert bam to sam
#!/bin/sh
for i in *.bam
do
  prefix=`echo $i | cut -d . -f 1-3`
  /data/home/lijiaj/software/samtools/bin/samtools view -h $i > $prefix.sam
done
