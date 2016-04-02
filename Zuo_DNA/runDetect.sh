#!/bin/sh
#A script use to run muTect detection
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn) till July, 2016
#History:
#	Jan 11 2016: First Release

ARR=`cat /data/home/chenjr/data/zuoxyProject/Sample.csv|awk 'BEGIN{FS=","}{print $3}'`
RUNHOME=/data/home/chenjr/data/zuoxyProject/results
SCRIPTHOME=/data/home/chenjr/operation/Zuo_DNA
i=0
N=$1
T=$2

for p in ${ARR}
do
        SAMPLE[${i}]=${p}
        i=$((i+1))
done

normalID=${SAMPLE[${N}]}
tumorID=${SAMPLE[${T}]}

echo "Pairs:"
echo ${normalID}
echo ${tumorID}
test -d $RUNHOME/log || mkdir -p $RUNHOME/log

bsub -q smp -n 16 -J ${normalID}.${tumorID} -e $RUNHOME/log/${normalID}.${tumorID}.err "sh $SCRIPTHOME/detect.sh ${normalID} ${tumorID} 1>$RUNHOME/log/${normalID}.${tumorID}.log 2"
