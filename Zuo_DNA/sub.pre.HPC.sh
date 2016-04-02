#!/bin/sh
L=$1
RUNHOME=/data/home/chenjr/data/zuoxyProject
SCRIPTHOME=/data/home/chenjr/operation/Zuo_DNA
ARR=`cat /data/home/chenjr/data/zuoxyProject/Sample.csv|awk 'BEGIN{FS=","}{print $3,$5,$2}'`
i=0

for p in $ARR
do 
	SAMPLE[$i]=$p 
	i=$((i+1))
done

k=$((L+1))
i=$(((k-1)*3))

ID=${SAMPLE[${i}]}
INDEX=${SAMPLE[$((i+1))]} 
LANE=${SAMPLE[$((i+2))]}
echo $ID
module load java/1.8.0_60
#module load python/2.7.10

test -d $RUNHOME/log || mkdir -p $RUNHOME/log
bsub -n 16 -J $ID -e $RUNHOME/log/$ID.err "sh $SCRIPTHOME/single.sh $ID $INDEX $LANE $RUNHOME 1>$RUNHOME/log/$ID.log 2"
