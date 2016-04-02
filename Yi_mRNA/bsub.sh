#!/bin/sh
module load java/1.8.0_60
#/data/home/chenjr/software/rsem-1.2.22/rsem-prepare-reference /data/home/chenjr/reference/genome/mrna_hg19.fa /data/home/chenjr/reference/genome/bowtie-indexes/mrna_hg19
#bowtie2-build ~/reference/genome/mrna_hg19.fa ~/reference/genome/bowtie-indexes/mrna_hg19
bsub -n 16 -o MA1.out sh RNASeq_bowtie2_rsem.sh MA1 GCCAAT
bsub -n 16 -o MB1.out sh RNASeq_bowtie2_rsem.sh MB1 AGTTCC
bsub -n 16 -o NC1.out sh RNASeq_bowtie2_rsem.sh NC1 CAGATC
bsub -n 16 -o MA2.out sh RNASeq_bowtie2_rsem.sh MA2 ATGTCA
bsub -n 16 -o MB2.out sh RNASeq_bowtie2_rsem.sh MB2 CCGTCC
bsub -n 16 -o NC2.out sh RNASeq_bowtie2_rsem.sh NC2 CTTGTA
