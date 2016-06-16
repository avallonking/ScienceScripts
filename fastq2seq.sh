#extract sequence from fastq
#!/bin/sh
for i in *.fastq
do
  t=`echo $i | cut -d . -f 1`
  bsub -J JiajinLi -n 1 -q smp -o fastq2seq.log 'cat '$i' | awk 'NR%4==2{print}' > '$t'.seq'
done
