#Extract sam from bam in guoym's data
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn)
#History:
# Wed 2016.3.30 Jiajin Li First Release
#!/bin/sh

dataPath=/data/home/guoym/1-NPC_genomics_project/1-NPC_WGS_data/2-alignment
samtoolsPath=/data/home/lijiaj/software/samtools/bin

$samtoolsPath/samtools view -h $dataPath/106B_WGC047825D_sorted.bam > 106B_WGC047825D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/112B_WGC047832D_sorted.bam > 112B_WGC047832D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/115B_WGC047824D_sorted.bam > 115B_WGC047824D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/117B_WGC047812D_sorted.bam > 117B_WGC047812D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/11B_WGC036258D_sorted.bam > 11B_WGC036258D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/124B_WGC052250D_sorted.bam > 124B_WGC052250D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/12B_DHG01982_sorted.bam > 12B_DHG01982_sorted.sam
$samtoolsPath/samtools view -h $dataPath/13B_WGC047833D_sorted.bam > 13B_WGC047833D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/140B_WGC052255D_sorted.bam > 140B_WGC052255D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/157B_WGC052256D_sorted.bam > 157B_WGC052256D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/159B_WGC052257D_sorted.bam > 159B_WGC052257D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/15B_WGC036260D_sorted.bam > 15B_WGC036260D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/1B_WGC047835D_sorted.bam > 1B_WGC047835D_sorted.sam
$samtoolsPath/samtools view -h $dataPath/2B_WGC036254D_sorted.bam > 2B_WGC036254D_sorted.sam
