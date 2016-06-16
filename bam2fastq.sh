#convert all bam in the same directory to fastq
#!/bin/sh
for i in *.bam
do
  name=`echo $i | cut -d . -f 1-2`
  /data/home/lijiaj/software/samtools/bin/samtools bam2fq -On -s $name.fastq $i
done
