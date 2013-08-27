#!/bin/bash -eux
source /etc/profile

# install nfs utilities and automount support
chroot "$CHROOT" emerge net-fs/nfs-utils

# Gentoo has sandbox issues with latest autofs builds
# https://bugs.gentoo.org/show_bug.cgi?id=453778
chroot "$CHROOT" /bin/bash <<DATAEOF
FEATURES="-sandbox" emerge --nospinner net-fs/autofs
DATAEOF
