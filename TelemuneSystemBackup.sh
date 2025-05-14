#!/bin/bash
#set -x
#Script Name: Telemune System Backup Script
#Description: Telemune System Backup it will take backup of CRBT servers
#Created by:  Manish
#From: Telemune Suppport Team
#Date: 08 April 2024

hostname=$(hostname)
# Backup date
Bkpdate=$(date "+%d-%m-%Y")

# Configuring  Destination Backup Path
rm -rf /home/SystemBackup/$Bkpdate
if [ ! -d "/home/SystemBackup/$Bkpdate" ]
then
    mkdir -p /home/SystemBackup/$Bkpdate
fi

tempdestination="/home/SystemBackup/$Bkpdate"
destination="/home/SystemBackup/"

users=("vcc" "Unipuser" "crbtuser" "sdpuser" "content" "xml" "teleswitch" "cse" "cms" "camp" "campaign" "ussdgw" "tomcat" "modtomcat" "portal" "mplace")
#Loop between users from User Variable

        for user in "${users[@]}"; do
        dev=(
                "/home/$user/.bash_profile"
                "/home/$user/scripts"
                "/home/$user/development"
                "/home/$user/IvrPrompts"
                "/home/$user/prompts/"
                "/home/$user/bin/"
                "/home/$user/procedure"
                "/home/$user/plivo"
                "/home/$user/.config/"
                "/home/$user/bulk_upload/"
        )

                for files in "${dev[@]}"; do
                if [ -e "$files" ]; then
                    echo "-----------------------------------"
                        echo "Reading files from $files "
                        filename=$(basename "$files")
                        mkdir -p "$tempdestination"/"$filename_$user"
                        cp -r "$files" "$tempdestination"/"$filename_$user"
                fi
                done

        tomcatpath=(
                "/home/$user/Apache_WebServer/7.0.63_Web/"
                "/home/$user/apache-tomcat-7.0.30/"
                "/home/$user/apache-tomcat-7.0.30_CCM/"
                "/home/$user/apache-tomcat-7.0.30_subengine/"
                "/home/$user/apache-tomcat-7.0.30_test/"
                "/home/$user/apache-tomcat-7.0.30_ussd/"
                "/home/$user/apache-tomcat-7.0.30_USSD/"
                "/home/$user/apache-tomcat-7.0.30_XML/"
                "/home/$user/apache-tomcat-7.0.47/"
                "/home/$user/apache-tomcat-7.0.68/"
                "/home/$user/apache-tomcat-8.0.30/"
                "/home/$user/Apache_WebServer/8.0.30_OBD/"
                "/home/$user/apache-tomcat-8.5.23/"
                "/home/$user/apache-tomcat-8.5.66_content/"
                "/home/$user/apache-tomcat-8.5.66_SMS/"
                "/home/$user/apache-tomcat-8.5.66_WEB/"
                "/home/$user/apache-tomcat-8.5.66_XML/"
                "/data/$user/apache-tomcat-8.5.66/"
                "/data/$user/apache-tomcat-8.5.66_content/"
                "/data/$user/apache-tomcat-8.5.66_IVR/"
                "/data/$user/apache-tomcat-8.5.66_OutReach/"
                "/data/$user/apache-tomcat-8.5.66_SMS/"
                "/data/$user/apache-tomcat-8.5.66_WEB/"
                "/data/$user/apache-tomcat-8.5.66_XML/"
                "/home/$user/apache-tomcat-9.0.16/"
                "/home/$user/apache-tomcat-9.0.16_MPADMIN/"
                "/home/$user/apache-tomcat-9.0.45/"
                "/home/$user/apache-tomcat-9.0.54/"
                "/home/$user/apache-tomcat-9.0.76/"
                "/home/$user/apache-tomcat-9.0.76_content/"
                "/home/$user/apache-tomcat-9.0.76_IVR/"
                "/home/$user/apache-tomcat-9.0.76_WEB/"
                "/home/$user/apache-tomcat-9.0.76_XML/"
                "/home/$user/WebServer-9.0.12/apache-tomcat/"
                "/home/$user/WebServer-9.0.12/apache-tomcat_CRBT/"
                "/home/$user/WebServer-9.0.12/apache-tomcat_IVR/"
                "/home/$user/WebServer-9.0.12/apache-tomcat_WEB/"
        )

                for tomcat in "${tomcatpath[@]}"; do
                if [ -e "$tomcat" ]; then
                    echo "-----------------------------------"
                        echo "Reading files from $tomcat "
                        filename=$(basename "$tomcat")
                        mkdir -p "$tempdestination"/"$filename_$user"
                        cp -r "$tomcat" "$tempdestination"/"$filename_$user"
                        echo "Removing Tomcat Logs from SystemBackup ..."
                        rm -rf $tempdestination/$user/apache*/logs/*
                fi
                done
        done

#     Place for adding list of back Files/Directories
    paths=(
                "/etc/sysconfig/network-scripts/"
                "/var/spool/cron/"
                "/etc/hosts"
                "/etc/rc.d/rc.local"
                "/usr/local/scripts/"
                "/usr/local/nsg"
                "/opt/DK/"
    )

    # Loop through the paths and perform the Backup
    for path in "${paths[@]}"; do
        if [ -e "$path" ]; then
            echo "-----------------------------------"
            echo "Reading files from $path "
            filename=$(basename "$path")
            cp -r "$path" "$tempdestination"/"$filename"
                rm -rf $tempdestination/nsg/log
        fi
    done
echo "-----------------------------------"

        echo "Starting Backup ..."

echo "-----------------------------------"
rm -rf $tempdestination/crbtuser/plivo/tmp  $tempdestination/sdpuser/plivo/tmp rm -rf $tempdestination/teleswitch/development/teleswitch/log
        cd $destination
        tar -czf $destination/TelemuneSystemBackup-$hostname-"$Bkpdate".tgz --exclude='OUT' $Bkpdate  2>/dev/null

        sleep 2
        echo "Removing Temporary Stored files at $tempdestination"
        rm -rf $tempdestination
#       cp  $destination/TelemuneSystemBackup-$hostname-"$Bkpdate".tgz $tempdestination/
echo "-----------------------------------"

        echo "Backup completed and  Saved at: $destination"

echo "-----------------------------------"
[root@app01 scripts]#
