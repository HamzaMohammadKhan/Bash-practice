#!/bin/bash

sudo touch /home/hamzamuhammad/files.log
logpath="/home/hamzamuhammad/files.log"
now=$(date +%d-%m-%Y-%H:%M:%S)

echo "-----$now----- Install nginx --- " | tee -a "$logpath"
echo "-----$now----- Install apache2 ---" | tee -a "$logpath"
echo "-----$now----- Install varnis ---" | tee -a "$logpath"
