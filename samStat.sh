#calculate mapped, overlap and total line number of a sam
#!/bin/sh
for i in *.sam
do
  bsub -J stat -n 1 -q smp -o stat.log '/data/home/lijiaj/software/samtools/bin/samtools view -c '$i''
  bsub -J stat -n 1 -q smp -o stat.log '/data/home/lijiaj/software/samtools/bin/samtools view -c -F 4 '$i''
  bsub -J stat -n 1 -q smp -o stat.log '/data/home/lijiaj/software/samtools/bin/samtools view -c -L /data/home/lijiaj/reference/Captured-regions_Nibergen_HG19_ExomeV3_UTR_flank_100bp.bed '$i''
done
