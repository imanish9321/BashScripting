#!/bin/bash
# Script: Getting PID of particular process and comparing cpu usage with threshold and terminate or generate Alert mail if required.
# Written By: Manish Yadav
# Company name: Telemune
# Date: 20-12-2023  04:57:21

echo "Getting pid of a particular process that needs to be monitored"
pname=RuleEngine
mpid=$(ps -ef | grep -i $pname | grep jar |awk '{print $2}')
echo "SMS.jar PID: $mpid"

echo "Generating CPU usage report taking interval 1 seconds"
date  >> "$pname"Cpu_Usage.out
top -b -d 1 -p $mpid  -n 1 | grep -A2 CPU >> "$pname"Cpu_Usage.out

echo "Getting CPU Usage data of $pname:"
cpu_value=$(top -b -d 1 -p $mpid  -n 1 | grep -A2 CPU |awk '{print $9}'| tail -1 | awk -F '.' '{print $1}')

if [ $cpu_value -le 900 ]
then
        echo "$pname CPU Usage Normal"
   #     netstat -anp | grep 9001| grep EST

else
        echo "$pname CPU Usgae above threshold: 900"
        kill -9 $mpid
        echo "Taking $pname restart"
        sleep 10
        npid=$(ps -ef | grep -i $pname | grep jar |awk '{print $2}')
        echo "$pname restarted with new pid: $npid"
  #      netstat -an | grep 9001 | grep EST
fi
