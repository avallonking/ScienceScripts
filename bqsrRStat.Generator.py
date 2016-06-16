#generate a R script for BQSR statistics
varname = ''
avoid_the_first = 1

log = open('stat.log','r')
script = open('bqsrStat.R','w')

for line in log:
    if line.startswith('~'):
        filename = line.split(' ')[3]
        varname = filename.split('.')[0] + filename.split('.')[1]
        script.write(varname + ' <- c(')
    if line[0].isdigit() and line.strip().split('\t')[1] != '0':
        script.write('rep(' + line.strip().split('\t')[0] + ',' + line.strip().split('\t')[1] + '),')
    elif 'Sender' in line:
        if avoid_the_first == 1:
            avoid_the_first = 0
        else:
            script.write(')')
            script.write('\nsummary(' + varname + ')\n')
            script.write('remove(' + varname + ')\n\n')

script.write(')')
script.write('\nsummary(' + varname + ')\n')
script.write('remove(' + varname + ')\n\n')

log.close()
script.close()
