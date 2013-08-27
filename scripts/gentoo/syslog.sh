#!/bin/bash -eux
source /etc/profile

# install system logger
chroot "$CHROOT" /bin/bash <<DATAEOF
emerge --nospinner app-admin/rsyslog
rc-update add rsyslog default
DATAEOF
