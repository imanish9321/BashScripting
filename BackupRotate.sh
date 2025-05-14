#!/bin/bash

Bkpdate=$(date "+%d-%m-%Y")
day_dir=`date +%Y_%m_%d`
# Files to Rotate
day_dir=`date +%Y_%m_%d`

appbkpapp01=TelemuneSystemBackup-app01-$Bkpdate.tgz
appbkpapp02=TelemuneSystemBackup-app02-$Bkpdate.tgz
appbkpdb01=TelemuneSystemBackup-db01-$Bkpdate.tgz
appbkpdb02=TelemuneSystemBackup-db02-$Bkpdate.tgz
dbbkpdb01=db_backup_$day_dir.tgz

# Login Credentials
USERNAME="suppport.user"
DESTINATION_LOCAL="/home/SystemBackup/$Bkpdate"
PASS='SU@$#2023'
pass='oracle'

rm -rf /home/SystemBackup/$Bkpdate
if [ ! -d "/home/SystemBackup/$Bkpdate" ]
then
    mkdir -p /home/SystemBackup/$Bkpdate
fi

echo "Getting Application Backup from Qcell SL APP01 10.130.5.10"
mv /home/SystemBackup/$appbkpapp01 /home/SystemBackup/$Bkpdate

echo "Getting Application Backup from Qcell SL APP02 10.130.5.11"
SOURCE_SERVER1="support.user@10.130.5.11:/home/SystemBackup/$appbkpapp02"
sshpass -p $PASS scp ${SOURCE_SERVER1} ${DESTINATION_LOCAL}

echo "Getting Application Backup from Qcell SL DB01 10.130.5.12"
SOURCE_SERVER2="support.user@10.130.5.12:/home/SystemBackup/$appbkpdb01"
sshpass -p $PASS scp ${SOURCE_SERVER2} ${DESTINATION_LOCAL}

echo "Getting Application Backup Data from Qcell SL DB02 10.130.5.13"
SOURCE_SERVER3="support.user@10.130.5.13:/home/SystemBackup/$appbkpdb02"
sshpass -p $PASS scp ${SOURCE_SERVER3} ${DESTINATION_LOCAL}

#echo "Getting Mysql Backup from Qcell SL DB01 10.130.5.12"
#SOURCE_SERVER4="oracle@10.130.5.12:/home/oracle/backup/mysql_db_dump/$dbbkpdb01"
#sshpass -p $pass scp ${SOURCE_SERVER4} ${DESTINATION_LOCAL}

chmod +x /home/SystemBackup/$Bkpdate/*
