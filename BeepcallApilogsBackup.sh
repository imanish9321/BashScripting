#!/bin/bash
#Script Name: BeepcallApi and BeppcallOutdail log rotate to shared storage Data_DB02
#Description: This script will check Beepcall and Beepoutdial Application logs more than 30 days and move to shared storage
#Created by:  Manish Yadav
#From: Mobileum Suppport Team
#Date: 18 Sepetember 2024
#set -x


hostinfo=$(hostname)
backup_month=$(date -d '1 month ago' "+%Y-%m")
backup_time=$(date -d '1 month ago' "+%d-%m-%Y %H")
filetimestamp=$(date -d '1 month ago' "+%m-%d-%Y")
echo "Taking Backup of BeepCallApi logs on $hostinfo of $backup_month  at: $backup_time"

################  BeepcallApi Log rotate to /Data_DB02/BeepcallApiBackup/ ############
Apifilepath=/home/vccuser/logs/BeepCall/BeepCallApi/"$backup_month"/
destdir=/Data_DB02/BeepcallApiBackup/"$hostinfo"/"$backup_month"/
if [ ! -d "$destdir" ]
then
mkdir -p "$destdir"
fi
mv $Apifilepath/beepCall-"$filetimestamp"* "$destdir"

################  BeepcallOutDail Log rotate to /Data_DB02/BeepcallOutDialBackup/ ############
Outfile=/home/vccuser/logs/BeepCall/BeepCallOut/"$backup_month"/
Outdestdir=/Data_DB02/BeepcallOutDialBackup/"$hostinfo"/"$backup_month"/
if [ ! -d "$Outdestdir" ]
then
mkdir -p "$Outdestdir"
fi
mv $Outfile/beepCall-"$filetimestamp"* "$Outdestdir"
