#!/bin/bash
now=$(date)

SLACK_WEBHOOK_URL=https://hooks.slack.com/services/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
SLACK_CHANNEL=general


overload() {
        color='danger'
        local message="payload={\"channel\": \"#$SLACK_CHANNEL\",\"attachments\":[{\"text\":\"$1\",\"color\":\"$color\"}]}"
        curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
}
not_overload() {
        color='good'
        local message="payload={\"channel\": \"#$SLACK_CHANNEL\",\"attachments\":[{\"text\":\"$1\",\"color\":\"$color\"}]}"
        curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
}

#cpu usage
#cpu=$(top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'|awk '{print "CPU Usage: " 100-$8 "%"}')
#echo "$cpu"

cpu=$(sar 1 5 | grep Average | awk '{print $3}')
mem_free=$(sar -r 5 5 | grep Average | awk '{print $5}')

#mem_usage
#mem_free=$(free -t | awk 'NR == 2 {printf("Current Memory Utilization is : %.2f%\n"), $3/$2*100}') 
#echo "$mem_free"

#disk_usage
#disk=$(df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}')
#echo "$disk"

INT1=${cpu/.*}
INT2=${mem_free/.*}
if [[ $INT1 -gt 80 || $INT2 -gt 80 ]];
then
        overload "System overload"
else
        not_overload "System load is OK!"
fi 

#slack
#curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$now ":" $cpu\n $now ":" $mem_free\n $now ":" $disk\n $now ":" $ip\n $now ":"  $totalcache"'"}' https://hooks.slack.com/services/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

