#!/bin/bash -eux

# fill all free hdd space with zeros
# true is added in case there is already "No space left on device"
dd if=/dev/zero of=/boot/EMPTY bs=1M || true
rm -f /boot/EMPTY

dd if=/dev/zero of=/EMPTY bs=1M || true
rm -f /EMPTY
