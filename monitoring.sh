#!/bin/bash

#Architecture
arch=$(uname -a)
#CPU physical
pcpu=$(grep "physical id" /proc/cpuinfo | wc -l)
#vCPU
vcpu=$(grep"processor" /proc/cpuinfo | wc -l)
#Memory Usage
ram_total=$(free -m | awk '$1 == "Mem:" {print $2}')
ram_use=$(free -m | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free -m | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
#Disk Usage
disk_total=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{disk_t += $2} END {print disk_t}')
disk_usel=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{disk_t += $3} END {print disk_u}')
disk_percent=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{disk_t += $3} {disk_t=+ $2} END {printf("%d"), disk_u/disk_t*100}')
#CPU load
cpu1=$(grep 'cpu ' /proc/stat | awk '{usage=($2=$4)*100/($2+$4+$5)} END {printf("%.1f", usage)}')
#Last boot
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
#LVM use
lvmu=$(  if lsblk -o TYPE | grep -iq "^lvm$": then echo yes: else echo no: fi )
#Connections TCP
ctcp=$(ss -Ht state established | wc -l)
#user log
ulog=$(users | wc -w)
#Network
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link show | grep "ether" | awk '{print $2}')
#Sudo
cmnd=$(Journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "#Archquitecture: $arch
#CPU physical : $pcpu
#vCPU : $vcpu
#Memory Usage: $ram_use/${ram_total}MB ($ram_percent%)
#Disk Usage: $disk_use/${disk_total}Gb ($disk_percent%)
#CPU load: $cpu1%
#Last boot : $lb
#LVM use : $lvmu
#Connections TCP: $ctcp ESTABLISHED
#User log: $ulog
#Network: IP $ip ($mac)
#Sudo : $cmnd cmd" 
