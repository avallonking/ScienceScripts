#sort and index vcf files
#!/bin/sh
module load java/1.8.0_60
for i in *.vcf
do
  java -jar /data/home/lijiaj/software/igvtools/IGVTools/igvtools.jar sort $i sorted.$i
  java -jar /data/home/lijiaj/software/igvtools/IGVTools/igvtools.jar index sorted.$i
done
