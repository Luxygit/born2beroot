#!/bin/bash

arch=$(uname -a)

pcpu=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)

vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

ram_total=$(free -m | awk '$1 == "Mem:" {print $2}')
ram_use=$(free -m | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free -m | awk '$1 == "Mem:" {printf "%.2f", $3/$2*100}')

disk_total=$(df -BG | grep '/dev/' | grep -v '/boot$' | awk '{disk_t += $2} END {print disk_t}')
disk_use=$(df -BM | grep '/dev/' | grep -v '/boot$' | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -BM | grep '/dev/' | grep -v '/boot$' | awk '{disk_u += $3} {disk_t+= $2} END {printf>

cpul=$(head -n1 /proc/stat | awk '{printf "%.1f%%", (($2+$3+$4)/($2+$3+$4+$5+$6+$7+$8)*100)"%"}')


lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

lvmu=$(if lsblk -o TYPE | grep -iq "lvm$"; then echo yes; else echo no; fi )

ctcp=$(ss -neopt state established | wc -l)

ulog=$(users | wc -w)

ip=$(hostname -I | awk '{print $1}')
mac=$(ip link show | grep "ether" | awk '{print $2}')

cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "#Architecture: $arch
        #CPU physical : $pcpu
        #vCPU : $vcpu
        #Memory Usage: $ram_use/${ram_total}MB ($ram_percent%)
        #Disk Usage: $disk_use/${disk_total}Gb ($disk_percent%)
        #CPU load: $cpul
        #Last boot : $lb
        #LVM use : $lvmu
        #Connections TCP: $ctcp ESTABLISHED
        #User log: $ulog
        #Network: IP $ip ($mac)
        #Sudo : $cmnd cmd" 

