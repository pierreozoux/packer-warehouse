#!/bin/bash -eux
source /etc/profile

which emerge

# add package keywords
cat <<DATAEOF >> "/etc/portage/package.keywords"
app-emulation/virtualbox-guest-additions $build_arch
DATAEOF

# unmask
cat <<DATAEOF >> "/etc/portage/package.unmask"
>=app-emulation/virtualbox-guest-additions-$vbox_version
DATAEOF

# install the virtualbox guest additions, add vagrant and root to group vboxguest
# PREREQUISITE: kernel - we install a module, so we use the kernel sources
emerge --nospinner sys-apps/dbus app-emulation/virtualbox-guest-additions

mkdir /media && chgrp vboxsf /media
rc-update add dbus default # required by virtualbox-guest-additions service
rc-update add virtualbox-guest-additions default
