#index all bam in this dir
#!/bin/sh
for i in *.sorted.bam
do
  bsub -J JiajinLi -q smp -n 8 -o index.log '~/software/samtools/bin/samtools index -b '$i''
done
