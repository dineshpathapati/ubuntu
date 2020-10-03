#!/bin/bash

#This script is used to mount a new disk in a ubuntu VM (mounted directory would be "/datadrive")
#Refer the below link before you execute this script
#https://docs.microsoft.com/en-us/azure/virtual-machines/linux/attach-disk-portal

#List of the disks and their UUID details for reference
sudo lsblk -e7
sudo blkid

#Partition New Disk
echo "Refer above output and Enter New data disk Logical volume Name above Eg: /dev/sda"
read LVD
sudo parted "$LVD" --script mklabel gpt mkpart  ext4 0% 100%

B=`echo $?`

#Formatting the New disk and assigning ext4 file system to it
if [ $B = 0 ]
then
echo "Enter data disk logical directory name after partitioning"
echo "If you had given /dev/sda in above input then it would be this value Example: /dev/sda1"
read LV
sudo mkfs.ext4 "$LV"
fi

B=`echo $?`

if [ $B = 0 ]
then
sudo partprobe "$LV"
fi

#Listing the VM Disk details to make it handy while giving inputs in the further process
lsblk -e7

#Listing UUID of the VM Disks to make it handy while giving inputs in the further process
blkid

#Creating New directory under root for mounting the new disk
cd /

sudo mkdir /datadrive

#Mounting a directory to the new drive
echo ">>Mounting the directory to the New drive<<< "

sudo mount "$LV"  /datadrive

#Editing fstab file to auto mount the data disk after reboots
echo "Enter the value to be data in the fstab file Example: UUID=33333333-3b3b-3c3c-3d3d-3e3e3e3e3e3e   /datadrive   ext4   defaults,nofail   1   2 "
read appendeddata
echo "New entry will look like below"
echo "$appendeddata"
echo "Is this okay?(y/n)"

read AN
a=y
test $AN = $a

B=`echo $?`

if [ $B = 0 ]
then
echo "$appendeddata" >>/etc/fstab
echo "Edited the /etc/fstab file"
lsblk -e7
else
echo "Sorry .. edit the file manually"
fi


