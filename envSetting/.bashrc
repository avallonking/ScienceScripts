# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
alias vim=/data/home/lijiaj/software/vim7.4/bin/vim
alias samtools=/data/home/lijiaj/software/samtools/bin/samtools
alias ruby=/data/home/lijiaj/software/ruby/bin/ruby
alias grep='grep --color=auto'
alias bj='bjobs'
alias bh='bhosts'
alias bp='bpeek -J'
alias d='df -h'
alias v='vim'
alias l='ls -hl'
module load python/2.7.10
module load java/1.8.0_60
module load R/3.2.2
module load samtools/1.3

bidle () {
  bhosts | awk '$2!="closed"{print $0}'
}

# ssh passwordless
if [ ! -f ~/.ssh/id_rsa ]; then
    echo 'No public/private RSA keypair found.'
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
    cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
    chmod 644 ~/.ssh/authorized_keys
    echo "StrictHostKeyChecking no" > ~/.ssh/config
    chmod 600 ~/.ssh/config
fi

#use zsh as my shell
#/bin/zsh
