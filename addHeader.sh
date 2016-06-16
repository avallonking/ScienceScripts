#add header.sam onto in.bam
#!/bin/sh
sample=$1
headerPath=/data/home/lijiaj/data/guoymProject/sample/header
samplePath=/data/home/lijiaj/data/guoymProject/sample/1X

for i in $samplePath/$sample/*
do
  /data/home/lijiaj/software/samtools/bin/samtools cat -h $headerPath/$sample.header.sam -o $i.added $i
done
