#!/bin/bash

Description: This script will accept username and password from script to create user and respective password. It is also ensures if required user is deleted.
Created By: Manish Yadav
Date: 10 October 2024

# This step will ask you username to be created
read -p "Enter Username: " username
useradd $username

# Getting Password from user input
read -s -p "Enter Password: " password

#Verify  Credentials
echo "Verify provided Credentials: $username::$password"

#This step will ask you if you are okay with provided credentials press Y to proceed for password creation otherwise press N 
read -p "Press Y to confirm for password creation or Press N for change: " confirmation
if [[ $confirmation == "Y" ]]
then
 echo "Details are Correct and verified therefore going to change password"
        echo $password | passwd --stdin $username
        echo "Password for $username" is set Successfully
else
 echo "User detail mismatch"
fi

# This step is added if you dont want to retain user created by this script
read -p "Press Y to delete or Press N for retain: " deletion
if [[ $deletion == "Y" ]]
then
 echo "Going to Delete user: $username"
 userdel -rf $username
else
 echo "User: $username will remain in system"
 userdetail=$(grep $username /etc/passwd)
 echo "$username is  created with $userdetail"
fi
