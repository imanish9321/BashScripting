#!/bin/bash
#Script Name: #CRBT_HourlySubscriptionReport.sh
#Description: This script will generate Hourly reports for CRBT Project
#Created by:  Manish Yadav
#From: Telemune Suppport Team
#Date: 05 April 2024
#set -x


lhour='1 hour ago'
timestamp=$(date -d "$lhour" "+%H")
timedate=$(date -d "$lhour" "+%Y-%m-%d %H")
stime=$(date -d "$lhour" "+%Y-%m-%d %H:00:00")
etime=$(date -d "$lhour"  "+%Y-%m-%d %H:59:59")
subtime='2023-10-01 00:00:00'
File=QcellslHourlySubReport
Filepath=/home/sdpuser/scripts/Reports
ReportMonth=$(date -d '1 hour ago' "+%d-%m-%Y")
#$$Filepath"$File"-"$ReportMonth".txt

# Function to execute MySQL queries and store results in variables
MysqlExecute()
{
    mysql -usdp -psdp sdp -h10.130.5.12 -se "$1"
}


if [ "$timestamp" -eq "00" ]
then
echo "Report Hour, Total Subscriber, Active Subscriber, Inactive Subscriber, New Subscribers, Subcription for 30 days,  Subcription for 7 days,  Subcription for 1 days, Total RBT Purchase, RBT Purchase 30 days, RBT Purchase 7 days, RBT Purchase 1 day, Unsub, Sub Using IVR, Sub using OBD, Sub using Web, Sub using CustCare, Sub using USSD, Sub via * Copy, Sub using SMS, UnSub using Web,UnSub using CustCare, UnSub using USSD, UnSub via IVR, UnSub using SMS, SUB Renewal, RBT Renewal" > $Filepath/$File-$ReportMonth.csv
fi

Total_Sub=$(MysqlExecute "select count(1) from crbt_subscriber_master where date_registered between '$subtime' and '$etime';")
Active_Sub=$(MysqlExecute "select count(1) from crbt_subscriber_master where date_registered between '$subtime' and '$etime' and STATUS ='A';")
Inactive_Sub=$(MysqlExecute "select count(1) from crbt_subscriber_master where date_registered between '$subtime' and '$etime' and STATUS ='I';")

New_Sub=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1;")
Sub_30_days=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1 and days = 30;")
Sub_7_days=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1 and days = 7;")
Sub_1_days=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1 and days = 1;")

Total_RBT_Purchase=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 3;")
RBT_Purchase_30_days=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 3 and days = 30;")
RBT_Purchase_7_days=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 3 and days = 7;")
RBT_Purchase_1_day=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 3 and days = 1;")

Unsub=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 9;")

Sub_Using_IVR=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1 and interface = 'I' ;")
Sub_using_OBD=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1 and interface = 'O';")
Sub_using_Web=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1 and interface = 'W';")
Sub_using_CustCare=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1 and interface = 'C';")
Sub_using_USSD=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1 and interface = 'U';")
Sub_via_star_Copy=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1 and interface = 'B';")
Sub_using_SMS=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 1 and interface = 'S';")

UnSub_using_Web=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 9 and interface = 'W';")
UnSub_using_CustCare=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 9 and interface = 'C';")
UnSub_using_USSD=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 9 and interface = 'U';")
UnSub_via_IVR=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 9 and interface = 'I';")
UnSub_using_SMS=$(MysqlExecute "select count(1) from crbt_cdrs where CREATE_DATE between '$stime' and '$etime' and action = 9 and interface = 'S';")

SUB_Renewal=$(MysqlExecute "select count(1) from crbt_cdrs where create_date between '$stime' and '$etime' and interface='M' and action='2';")

RBT_Renewal=$(MysqlExecute "select count(1) from crbt_cdrs where create_date between '$stime' and '$etime' and interface='M' and action='3';")

echo $timedate,$Total_Sub,$Active_Sub,$Inactive_Sub,$New_Sub,$Sub_30_days,$Sub_7_days,$Sub_1_days,$Total_RBT_Purchase,$RBT_Purchase_30_days,$RBT_Purchase_7_days,$RBT_Purchase_1_day,$Unsub,$Sub_Using_IVR,$Sub_using_OBD,$Sub_using_Web,$Sub_using_CustCare,$Sub_using_USSD,$Sub_via_star_Copy,$Sub_using_SMS,$UnSub_using_Web,$UnSub_using_CustCare,$UnSub_using_USSD,$UnSub_via_IVR,$UnSub_using_SMS,$SUB_Renewal,$RBT_Renewal >>$Filepath/$File-$ReportMonth.csv

