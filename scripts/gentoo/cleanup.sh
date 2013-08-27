#!/bin/bash -eux

#remove tmp files
rm /root/kernel_version
rm /etc/profile.d/settings.sh
rm /etc/profile.d/stage3.sh

# fix a weird issue with sshd not starting
# http://www.linuxquestions.org/questions/linux-networking-3/sshd-fatal-daemon-failed-no-such-device-279664/
rm -f /dev/null
mknod /dev/null c 1 3
chmod 0666 /dev/null

# skip all the news
/usr/bin/eselect news read all

# cleanup
# delete tmp, cached and build artifact data
eclean -d distfiles
rm /tmp/*
rm -rf /var/log/*
rm -rf /var/tmp/*
rm -rf /root/.gem

#clean root
rm /root/*

# fill all swap space with zeros and recreate swap
swapoff /dev/sda3
shred -n 0 -z /dev/sda3
mkswap /dev/sda3
