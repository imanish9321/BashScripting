#!/bin/bash
set -x

######## Printing Log Info #########
BackupMonth=1
log_month=$(date -d "$BackupMonth"' months ago' '+%B %Y' )
echo Rotating Logs For Month: $log_month

######## Checking Logs of Previous month #######
previous_month=$(date -d "$BackupMonth"' month ago' '+%m_%Y')
Backup_file=$(date -d "$BackupMonth"' months ago' '+%m-%Y')
filepath=/home/vccuser/logs/BeepGateway

###### SubmitSmLogArch Cleanup ######
SubmitSmfile=SubmitSmlogARCH/SubmitSmlogArc*_*_"$previous_month".d
if [[ -f ""$filepath"/SubmitSmlogARCH/SubmitSmlogArc00_01_"$previous_month".d" ]]
then
        echo "SubmitSmLog rotation started as old logs are present"
        tar -cvzf $filepath/SubmitSmlogARCH/SubmitSmlogArc-"$Backup_file".tgz $filepath/$SubmitSmfile --remove-files &
else
        echo "Skipping as logs are already rotated"
fi

###### SubmitSmResArc Cleanup ######
SubmitResfile=SubmitSmResARCH/SubmitSmResponselogArc*_*_"$previous_month".d
if [[ -f ""$filepath"/SubmitSmResARCH/SubmitSmResponselogArc00_01_"$previous_month".d" ]]
then
        echo "SubmitSmResLog rotation started as old logs are present"
        tar -cvzf $filepath/SubmitSmResARCH/SubmitSmResponselogArc-"$Backup_file".tgz $filepath/$SubmitResfile --remove-files &
else
        echo "Skipping as logs are already rotated"
fi
###### DelReLogArch Cleanup ######
DelReFile=delReArch/deliveryReportlogAch*_*_"$previous_month".d

if [[ -f ""$filepath"/delReArch/deliveryReportlogAch00_01_"$previous_month".d" ]]
then
        echo "DeRe Log rotation started as old logs are present"
        tar -cvzf "$filepath"/delReArch/deliveryReportlogAch-"$Backup_file".tgz $filepath/$DelReFile --remove-file &
else
        echo "Skipping as logs are already rotated"
fi
