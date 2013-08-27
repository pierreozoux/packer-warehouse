#!/bin/bash -eux

# fill all free hdd space with zeros
dd if=/dev/zero of=/boot/EMPTY bs=1M
rm -f /boot/EMPTY

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

