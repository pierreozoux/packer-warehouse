#!/bin/bash -eux
source /etc/profile

cat <<DATAEOF >> "$CHROOT/etc/portage/package.keywords"
dev-util/kbuild ~$build_arch
DATAEOF

# Kernel Version
chroot "$CHROOT" /bin/bash -eux<<DATAEOF
emerge --color n --nospinner --search gentoo-sources | grep 'Latest version available' | cut -d ':' -f 2 | tr -d ' ' > /root/kernel_version
DATAEOF

kernel_version=$(cat $CHROOT/root/kernel_version)

echo "export kernel_version=$kernel_version" >> /etc/profile.d/settings.sh

mv /tmp/kernel.config $CHROOT/tmp/kernel.config

# get, configure, compile and install the kernel and modules
chroot "$CHROOT" /bin/bash -eux<<DATAEOF
USE="symlink" emerge --nospinner =sys-kernel/gentoo-sources-$kernel_version sys-kernel/genkernel gentoolkit
cd /usr/src/linux
# use a default configuration as a starting point
make defconfig

# add settings for VirtualBox kernels to end of .config
cat /tmp/kernel.config >> ./.config

# build and install kernel, using the config created above
genkernel --install --symlink --oldconfig --bootloader=grub all

# keep track of the kernel version
cp arch/x86/boot/bzImage /boot/kernel-$kernel_version-gentoo
DATAEOF
