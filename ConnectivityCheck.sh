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
APP02='192.168.1.100'
DB01='192.168.1.101'
DB02='192.168.1.102'
MscIP='192.168.1.103'
MgwIP='192.168.1.104'
HlrIP='192.168.1.105'
ChargingIP='192.168.1.106'
SmscIP='192.168.1.107'

#### List of Ports
SipPort='22'
HlrPort='25'
ChargingPort='57'
SmscPort='80'

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

cat logo.txt

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

#        echo "Running Telnet Command"
        output=$( (echo "quit" | timeout 5 telnet "$IP" "$PORT" 2>&1) | grep "Connected" )
        if [[ "$output" == *"Connected"* ]]; then
            echo -e "Telnet Result: ${GREEN} Success ${NC}"
        else
            echo -e "Telnet Result: ${RED} Fail ${NC}"
        fi

#       echo "Running Netstat Command"
        conn=$(netstat -an | grep "$IP:$PORT" | grep -c ESTABLISHED | grep -v Not )
        echo "No of Connections Established: $conn"

    else
        echo -e "Ping Result : ${RED} Fail ${NC}"
        echo "Running Traceroute Command"
        traceroute "$IP"
    fi
}

echo "########################################################"
echo "Performing Connectivity Check on: $SOURCE_IP" at: $date
echo "########################################################"
sleep 1
echo "***********************************************"
echo "Starting Internal Connectivity Check on Server IP: $APP02"
echo "***********************************************"
echo "Running connectivity_check command"
connectivity_check $APP02
sleep 1

echo "***********************************************"
echo "Starting Internal Connectivity Check on Server IP: $DB01"
echo "***********************************************"
echo "Running connectivity_check command"
connectivity_check $DB01
sleep 1

echo "***********************************************"
echo "Starting Internal Connectivity Check on Server IP: $DB02"
echo "***********************************************"
echo "Running connectivity_check command"
connectivity_check $DB02
sleep 1

echo "***********************************************"
echo "Starting MSC Connectivity Check MSC IP: $MscIP"
echo "***********************************************"
echo "Running connectivity_check command"
connectivity_check $MscIP
sleep 1

echo "*******************************************************"
echo "Starting MediaGateway Connectivity Check MGW IP: $MgwIP"
echo "*******************************************************"
echo "Running connectivity_check Command"
connectivity_check $MgwIP
sleep 1

echo "**********************************************"
echo "Starting HLR Connectivity Check HLR IP: $HlrIP"
echo "**********************************************"
echo "Running connectivity_check Command"
connectivity_check $HlrIP $HlrPort
sleep 1

echo "************************************************************"
echo "Starting Charging Connectivity Check ChargingIP: $ChargingIP"
echo "************************************************************"
echo "Running connectivity_check Command"
connectivity_check $ChargingIP $ChargingPort
sleep 1

echo "*************************************************"
echo "Starting SMSC Connectivity Check SMSC IP: $SmscIP"
echo "*************************************************"
echo "Running connectivity_check Command"
connectivity_check $SmscIP $SmscPort
