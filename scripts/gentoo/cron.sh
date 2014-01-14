#!/bin/bash -eux
source /etc/profile

# install cron
chroot "$CHROOT" /bin/bash -eux<<DATAEOF
emerge --nospinner sys-process/vixie-cron
rc-update add vixie-cron default
DATAEOF
