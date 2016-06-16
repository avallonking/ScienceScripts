#report idle nodes every hour(use crontab), and mail to me if there are idle nodes
#!/bin/sh

#Environment loading
source /etc/profile
source /data/home/lijiaj/.bash_profile

#Function
bidle () {
    /share/apps/platform/lsf/9.1/linux2.6-glibc2.3-x86_64/bin/bhosts | awk '$2!="closed"{print $0}'
}

#Variable
first_idle_node=`bidle | awk 'NR==2{print $1}'`

#Main
if [[ $first_idle_node == c[0-9]* ]]; then
  bidle | mail -s "Current Idle Normal Nodes" lijj36@mail2.sysu.edu.cn
fi
