#a program for calling
#!/bin/sh
file=$1
echo $file
cat $file | awk 'NR>100{print $5}' > $file.mapq.txt
