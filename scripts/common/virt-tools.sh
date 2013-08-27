#!/bin/bash -eux

if [ -f /home/vagrant/.vbox_version ]; then
    mkdir /tmp/vbox
    VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
    mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /tmp/vbox 
    sh /tmp/vbox/VBoxLinuxAdditions.run
    umount /tmp/vbox
    rmdir /tmp/vbox
    rm *.iso
fi

if [ -f /home/vagrant/.vmfusion_version ]; then
    #Set Linux-specific paths and ISO filename
    home_dir="/home/vagrant"
    iso_name="linux.iso"
    mount_point="/tmp/vmware-tools"
    #Run install, unmount ISO and remove it
    mkdir ${mount_point}
    cd ${home_dir}
    /bin/mount -o loop ${iso_name} ${mount_point}
    tar zxf ${mount_point}/*.tar.gz && cd vmware-tools-distrib && ./vmware-install.pl --default
    /bin/umount ${mount_point}
    /bin/rm -rf ${home_dir}/${iso_name} ${home_dir}/vmware-tools-distrib
    rmdir ${mount_point}
fi
