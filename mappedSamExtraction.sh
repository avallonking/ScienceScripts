#!/bin/shell
#A program for the extraction of mapped bam
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn)
#History:
#	Jan 23	First Release
for i in *.sam
do
	/data/home/lijiaj/software/samtools/bin/samtools view -F 4 $i > mapped.$i
done
