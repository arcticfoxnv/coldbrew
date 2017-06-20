#!/bin/bash

set -ex

mount -t iso9660 -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
yes | sh /mnt/VBoxLinuxAdditions.run
umount /mnt

exit 0
