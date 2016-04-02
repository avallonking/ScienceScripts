#!/bin/shell
#A program for the extraction of mapped bam
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn)
#History:
#	Jan 23	First Release
for i in ./*.bam
do
	/data/home/lijiaj/software/samtool/bin/samtools view -b -F 4 $i > $i.mapped.bam
done
