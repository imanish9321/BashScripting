#!/bin/bash
#Script Name: Connectivity Check
#Description: This script will check connectivity Status and Report problems. This script will perform ping, telnet, netstat and traceroute commands
#Created by: Manish Yadav
#From: Telemune Suppport Team
#Date: 17 April 2025
#set -x

date=$(date "+%d-%m-%Y %H:%M")

#List of IP addresses
SOURCE_IP=`hostname -i`
APP02='192.168.1.11'
DB01='192.168.1.12'
DB02='192.168.1.13'
MscIP='192.168.1.14'
MgwIP='192.168.1.15'
HlrIP='192.168.1.16'
ChargingIP='192.168.1.17'
SmscIP='192.168.1.18'

#### List of Ports
SipPort='5060'
HlrPort='3000'
ChargingPort='8008'
SmscPort='5001'

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# This Function will check for Connectivity in Phased manner: 1. Ping Okay-> Netstat, Telnet 2. Ping Fail -> Traceroute
connectivity_check()
{
    IP="$1"
    PORT="$2"
    PING_RESP=$(ping -c2 "$IP" | grep -E "2 received|0% packet loss" | awk -F ',' '{print $2,$3}')

    if [[ "$PING_RESP" == *"2 received"* && "$PING_RESP" == *"0% packet loss"* ]]
        then
                echo -e "Ping Result : ${GREEN} Success ${NC}"

        # Proceed only if the port is provided
        if [[ -z "$PORT" ]]; then
                echo "Port not provided so, skipping netstat and telnet."
            return
        fi
        echo "Running Netstat Command"
        conn=$(netstat -an | grep "$IP:$PORT" | grep -c ESTABLISHED | grep -v Not )
        echo "No of Connections Established: $conn"

        echo "Running Telnet Command"
        output=$( (echo "quit" | timeout 5 telnet "$IP" "$PORT" 2>&1) | grep "Connected" )
        if [[ "$output" == *"Connected"* ]]; then
            echo -e "Telnet Result: ${GREEN} Success ${NC}"
        else
            echo -e "Telnet Result: ${RED} Fail ${NC}"
        fi
    else
        echo -e "Ping Result : ${RED} Fail ${NC}"
        echo "Running Traceroute Command"
        traceroute "$IP"
    fi
}

echo "########################################################"
echo "Performing Connectivity Check on: $SOURCE_IP" at: $date
echo "########################################################"

echo "***********************************************"
echo "Starting Internal Connectivity Check on Server IP: $APP02"
echo "***********************************************"
echo "Running connectivity_check command"
connectivity_check $APP02

echo "***********************************************"
echo "Starting Internal Connectivity Check on Server IP: $DB01"
echo "***********************************************"
echo "Running connectivity_check command"
connectivity_check $DB01

echo "***********************************************"
echo "Starting Internal Connectivity Check on Server IP: $DB02"
echo "***********************************************"
echo "Running connectivity_check command"
connectivity_check $DB02


echo "***********************************************"
echo "Starting MSC Connectivity Check MSC IP: $MscIP"
echo "***********************************************"
echo "Running connectivity_check command"
connectivity_check $MscIP

echo "*******************************************************"
echo "Starting MediaGateway Connectivity Check MGW IP: $MgwIP"
echo "*******************************************************"
echo "Running connectivity_check Command"
connectivity_check $MgwIP

echo "**********************************************"
echo "Starting HLR Connectivity Check HLR IP: $HlrIP"
echo "**********************************************"
echo "Running connectivity_check Command"
connectivity_check $HlrIP $HlrPort

echo "************************************************************"
echo "Starting Charging Connectivity Check ChargingIP: $ChargingIP"
echo "************************************************************"
echo "Running connectivity_check Command"
connectivity_check $ChargingIP $ChargingPort

echo "*************************************************"
echo "Starting SMSC Connectivity Check SMSC IP: $SmscIP"
echo "*************************************************"
echo "Running connectivity_check Command"
connectivity_check $SmscIP $SmscPort
