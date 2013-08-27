#!/bin/bash -eux
source /etc/profile

# add default users and groups, setpasswords, configure privileges and install sudo
# PREREQUISITE: virtualbox guest additions - need the vboxguest group to exist

# add vagrant user
groupadd -r vagrant
useradd -m -r vagrant -g vagrant -G wheel,vboxsf,vboxguest -c 'added by vagrant, packer basebox creation'

passwd vagrant<<EOF
$PASSWORD
$PASSWORD
EOF

# to each its own... home
chown -R vagrant /home/vagrant

emerge --nospinner app-admin/sudo

echo 'sshd:ALL' > /etc/hosts.allow
echo 'ALL:ALL' > /etc/hosts.deny
