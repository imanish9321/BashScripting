#!/bin/bash
#Script Name: Application Health Check Script
#Description: This script will perform Application Health Check in VCC 
#Created by:  Manish Yadav
#From: Telemune Suppport Team
#Date: 01 May 2025
#set -x

timestamp=$(date "+%d-%m-%Y %H:%M")
echo -e "\nInitiating Application Health Check ...\n"
echo "VCC:Expresso Application Health Check on $host at $timestamp"
host=`hostname`

cat logo.txt

echo "------------------------------------------------------------"
printf "%-25s %-10s %-15s %-10s\n" "Application Name" "PID" "Start Time" "Status"
echo "------------------------------------------------------------"

# Define applications list
ApplicationList=("TelePlivo.jar" "esl.jar" "mcaHandler.jar" "vcc_hlr.jar" "mcaCharging.jar" "mcaRuleEngine.jar" "SMSGateway_JAVA.jar" "vcc_delivery_engine.jar" "Send_Email.jar")

# list running applications
for application in "${ApplicationList[@]}"; do
    check=$(ps -ef | grep "$application" | grep -v grep)

    if [[ ! -z "$check" ]]; then
        pid=$(echo "$check" | awk '{print $2}')
        start_time=$(echo "$check" | awk '{print $5}')
        printf "%-25s %-10s %-15s %-10s\n" "$application" "$pid" "$start_time" "Success"
    fi
done
# list applications that are not running
for application in "${ApplicationList[@]}"; do
    check=$(ps -ef | grep "$application" | grep -v grep)

    if [[ -z "$check" ]]; then
        printf "%-25s %-10s %-15s %-10s\n" "$application"  "NA" "NA" "Failed"
    fi
done
