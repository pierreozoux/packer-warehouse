#!/bin/bash -eux
source /etc/profile

# partition the disk (http://www.rodsbooks.com/gdisk/sgdisk.html)
sgdisk -n 1:0:+128M -t 1:8300 -c 1:"linux-boot" \
       -n 2:0:+32M  -t 2:ef02 -c 2:"bios-boot"  \
       -n 3:0:+1G   -t 3:8200 -c 3:"swap"       \
       -n 4:0:0     -t 4:8300 -c 4:"linux-root" \
       -p /dev/sda

sleep 1

# format partitions, mount swap
mkswap /dev/sda3
swapon /dev/sda3
mkfs.ext2 /dev/sda1
mkfs.ext4 /dev/sda4

# mount other partitions
mount /dev/sda4 "$CHROOT" && cd "$CHROOT" && mkdir boot && mount /dev/sda1 boot

# download stage 3, unpack it, delete the stage3 archive file
echo "Downloading $stage3url ..."
wget -nv --tries=5 "$stage3url"
tar xpf "$stage3file" && rm "$stage3file"

# prepeare chroot, update env
mount --bind /proc "$CHROOT/proc"
mount --bind /dev "$CHROOT/dev"

# copy nameserver information, save build timestamp
cp /etc/resolv.conf "$CHROOT/etc/"
date -u > "$CHROOT/etc/vagrant_box_build_time"
chroot "$CHROOT" env-update

# disable systemd device naming
chroot "$CHROOT" /bin/bash <<DATAEOF
ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules
DATAEOF

# bring up eth0 and sshd on boot
chroot "$CHROOT" /bin/bash <<DATAEOF
cd /etc/conf.d
echo 'config_eth0=( "dhcp" )' >> net
ln -s net.lo /etc/init.d/net.eth0
rc-update add net.eth0 default
rc-update add sshd default
DATAEOF

# set fstab
cat <<DATAEOF > "$CHROOT/etc/fstab"
# <fs>                  <mountpoint>    <type>          <opts>                   <dump/pass>
/dev/sda1               /boot           ext2            noauto,noatime           1 2
/dev/sda3               none            swap            sw                       0 0
/dev/sda4               /               ext4            noatime                  0 1
none                    /dev/shm        tmpfs           nodev,nosuid,noexec      0 0
DATAEOF

# set make options
cat <<DATAEOF > "$CHROOT/etc/portage/make.conf"
CHOST="$chost"

CFLAGS="-mtune=generic -O2 -pipe"
CXXFLAGS="\${CFLAGS}"

ACCEPT_KEYWORDS="\${build_arch}"
MAKEOPTS="-j$((1 + $nr_cpus)) -l$nr_cpus.5"
EMERGE_DEFAULT_OPTS="-j$nr_cpus --quiet-build=y"
FEATURES="\${FEATURES} parallel-fetch"

# english only
LINGUAS=""

# for X support if needed
INPUT_DEVICES="evdev"
VIDEO_CARDS="virtualbox"
DATAEOF

# set localtime
chroot "$CHROOT" ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime

# set locale
chroot "$CHROOT" /bin/bash <<DATAEOF
echo LANG=\"$LOCALE\" > /etc/env.d/02locale
env-update && source /etc/profile
DATAEOF

# update portage tree to most current state
# emerge-webrsync is recommended by Gentoo for first sync
chroot "$CHROOT" /bin/bash <<DATAEOF
# update the country where to sync
echo SYNC=\"rsync://rsync$COUNTRY_SYNC_SERVER.gentoo.org/gentoo-portage\" >> /etc/portage/make.conf

echo "updating Portage Tree..."
emerge --sync --quiet

if $SEARCH_FASTEST_MIRROR ; then
  emerge --nospinner mirrorselect
  mirrorselect -s3 -b10 -o -D >> /etc/portage/make.conf
fi
DATAEOF
