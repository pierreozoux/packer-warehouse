#!/bin/bash -eux
source /etc/profile

# use grub2
cat <<DATAEOF >> "$CHROOT/etc/portage/package.keywords"
sys-boot/grub:2
DATAEOF

# install grub
chroot "$CHROOT" emerge --nospinner grub

# tweak timeout
chroot "$CHROOT" sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/g" /etc/default/grub

# make the disk bootable
chroot "$CHROOT" /bin/bash -eux<<DATAEOF
source /etc/profile && \
env-update && \
grep -v rootfs /proc/mounts > /etc/mtab && \
mkdir /boot/grub2 && \
grub2-mkconfig -o /boot/grub2/grub.cfg && \
grub2-install --no-floppy /dev/sda
DATAEOF
