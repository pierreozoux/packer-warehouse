#!/bin/bash -eux
vbox_version=$(cat /root/.vbox_version)
echo "export vbox_version=$vbox_version" >> /etc/profile.d/settings.sh

cp /etc/profile.d/* $CHROOT/etc/profile.d/

chroot $CHROOT /bin/bash -eux<<DATAEOF
# set passwords (for after reboot)
passwd<<EOF
$PASSWORD
$PASSWORD
EOF
DATAEOF

/sbin/reboot
ps aux | grep sshd | grep -v grep | awk '{print $2}' | xargs kill
