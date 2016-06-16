#convert sam to bam
#!/bin/sh
for i in *.sam
do
  name=`echo $i | cut -d . -f 1-3`
  /data/home/lijiaj/software/samtools/bin/samtools view -b $i > $name.bam
done
