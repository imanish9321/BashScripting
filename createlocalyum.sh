#!/bin/bash
#Script Name: localYumCreate.sh
#Description: This script will create local yum server from ISO mounted to server or copy RPM's to server and create yum
#Created by:  Manish Yadav
#From: Telemune Suppport Team
#Date: 12 February 2024

mkdir /packages
#Mount ISO files to /mnt location
mount /dev/sr1 /mnt

cp -rv /mnt/Packages/* /packages/
rpm -ivh /packages/deltarpm-3.6-3.el7.x86_64.rpm
rpm -ivh /packages/libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm
rpm -ivh /packages/python-deltarpm-3.6-3.el7.x86_64.rpm
rpm -ivh /packages/createrepo-0.9.9-28.el7.noarch.rpm 
createrepo /packages
rm -rf /etc/yum.repos.d/*
touch /etc/yum.repos.d/yum.repo
echo "[repo_id]" >> /etc/yum.repos.d/yum.repo
echo "name=yum" >> /etc/yum.repos.d/yum.repo
echo "baseurl=file:///packages" >> /etc/yum.repos.d/yum.repo
echo "enabled=1" >> /etc/yum.repos.d/yum.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/yum.repo

yum clean all
yum repolist all
