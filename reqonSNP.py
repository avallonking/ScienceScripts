#extract SNP from .vcf for ReQON for BQSR. The final file contain two
#columns, one is chr name, the other is position
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn)
#History:
# 2016.3.17 First Release
list = ['dbsnp_138.hg19.vcf','Mills_and_1000G_gold_standard.indels.hg19.sites.vcf','1000G_phase1.snps.high_confidence.hg19.sites.vcf']
for data in list:
  f1 = open(data,'r')
  f2 = open(data.split('.')[0]+'.txt','w')
  for line in f1:
    if line.startswith('c'):
      f2.write(line.split('\t')[0] + '\t' + line.split('\t')[1] + '\n')
  f1.close()
  f2.close()
