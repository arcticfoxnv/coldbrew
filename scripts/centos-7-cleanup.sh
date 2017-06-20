#!/bin/bash

set -ex

cat /dev/null > /var/log/audit/audit.log
cat /dev/null > /var/log/boot.log
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/maillog
cat /dev/null > /var/log/messages
cat /dev/null > /var/log/secure
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/yum.log

rm -rf /var/log/anaconda
rm -f /var/log/vboxadd-install*.log
rm -f /var/log/VBoxGuestAdditions.log

rm -f /home/vagrant/VBoxGuestAdditions.iso
swapoff -a
export $(blkid -o export /dev/sda2 | grep UUID)
export OLDUUID=${UUID}

set +e
dd if=/dev/zero of=/dev/sda2
dd if=/dev/zero of=/z; rm -f /z
dd if=/dev/zero of=/boot/z; rm -f /boot/z

set -e
mkswap /dev/sda2
export $(blkid -o export /dev/sda2 | grep UUID)
sed -e "s/${OLDUUID}/${UUID}/g" /etc/fstab -i

exit 0
