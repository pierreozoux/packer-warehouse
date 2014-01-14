#!/bin/bash -eux
source /etc/profile

# install grub
chroot "$CHROOT" emerge --nospinner sys-boot/grub:2
# make the disk bootable
chroot "$CHROOT" /bin/bash -eux<<DATAEOF
mkdir /boot/grub
grub2-install /dev/sda
grub2-mkconfig -o /boot/grub/grub.cfg
DATAEOF
