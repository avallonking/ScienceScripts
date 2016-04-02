#extract ref from ucsc.hg19.fasta for ReQON.
#Requirements:
#col1: chr  col2: pos col3: nucleotide
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn)
#History:
# 2016.3.17 First Release

f1 = open('ucsc.hg19.fasta','r')
f2 = open('ucsc.hg19.chr1.ref.txt','w')
pos = 0
tag = 0
for line in f1:
  if tag == 0:
    if line == ">chr1\n":
      chr = line.strip('>\n')
      tag = 1
  else:
    if line.startswith('>'):
      break
    else:
      read = line.upper().strip()
      for base in read:
        pos += 1
        f2.write(chr + '\t' + str(pos) + '\t' + base + '\n')
f1.close()
f2.close()
