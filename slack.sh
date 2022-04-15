#!/bin/bash

#cpu_usage
cpu=$(top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'|awk '{print "CPU Usage: " 100-$8 "%"}')
#cpu_idle=`top -b -n 1 | grep Cpu | awk '{print 100-$8 "%"}'|cut -f 1 -d "."`
#cpu_use=`expr 100 - $cpu_idle`
#echo  "cpu utilization: $cpu_use"
#curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$cpu"'"}' https://hooks.slack.com/services/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


#mem_usage 
#mem_free=`free -m | grep "Mem" | awk '{print $4+$6}'`
mem_free=$(free -t | awk 'NR == 2 {printf("Current Memory Utilization is : %.2f%\n"), $3/$2*100}') 
#echo "memory space remaining : $mem_free"
echo "$mem_free"

#disk_usage
disk=$(df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}')
echo "$disk"

#varnish_usage 

#ip
ip=$(curl ipinfo.io/ip/)
echo "$ip"

#slack
curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$cpu\n $mem_free\n $disk \n $ip"'"}' https://hooks.slack.com/services/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

