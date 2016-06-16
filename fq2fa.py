#convert certain fastq files to fasta
filelist = ['NIST7086.1.fastq','NIST7086.2.fastq','NIST7035.1.fastq','NIST7035.2.fastq']
for file in filelist:
    try:
        fq = open(file,'r')
        fa = open((file[0:10]+'.fasta'),'w')
        for line in fq:
            if '@HWI-D00119' in line:
                tag = 1
                fa.write('>' + line[1:-1] + '\n')
                continue
            if tag == 1:
                fa.write(line)
                tag = 0
        fq.close()
        fa.close()
    except IOError:
        print file + ' not found'
        continue
