#!/bin/bash
set -x

# Backup date
Bkpdate=$(date "+%d-%m-%Y")

# Destination directory for storing backup
rm -rf /home/vccuser/backup/$Bkpdate
if [ ! -d "/home/vccuser/backup/$Bkpdate" ]
then
    mkdir /home/vccuser/backup/$Bkpdate
fi

tempdestination="/home/vccuser/backup/$Bkpdate"
destination="/home/vccuser/backup/"

# Provide usernames for backup 
users=("vccuser" "test")
# Loop through each user
for user in "${users[@]}"; do

# Provide list of back paths
paths=(
	"/home/$user/.bash_profile"
	"/home/$user/scripts/"
      )

# Loop through the paths and perform the backup
	for path in "${paths[@]}"; do
	    if [ -e "$path" ]; then
		echo "-----------------------------------"
	
			echo "Copying files from $path "	
	
		    filename=$(basename "$path")
	        	cp -r  "$path" "$tempdestination"/"$filename"_"$user"
		
	    else
	        echo "Error: File not found - $path"
	    fi
	done
done
echo "-----------------------------------"

	echo "Starting Backup ..."

echo "-----------------------------------"
	cd $destination 
	tar -czf $destination/VccSystembackup-"$Bkpdate".tgz --exclude='OUT' $Bkpdate  2>/dev/null
	sleep 2

	echo "Removing Temporary Stored files at $tempdestination"
	rm -rf $tempdestination	
sleep 1
	echo "Backup Successfully Saved at: $destination"

echo "-----------------------------------"

        echo "Backup completed successfully."

echo "-----------------------------------"
