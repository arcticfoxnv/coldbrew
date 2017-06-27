#!/bin/bash

set -ex

mount -t iso9660 -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
yes | sh /mnt/VBoxLinuxAdditions.run
umount /mnt

VER=$(cat /tmp/boxversion)
echo "===== Box Version =====" > /home/vagrant/boxversion
echo "base: ${VER}" >> /home/vagrant/boxversion

exit 0
