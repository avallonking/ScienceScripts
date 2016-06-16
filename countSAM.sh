#count the lines of a SAM
#!/bin/sh
for i in *.sam
do
  bsub -J countSAM -n 1 -o countSAM.log 'wc -l '$i''
done
