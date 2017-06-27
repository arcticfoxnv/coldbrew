#!/bin/bash

set -ex

yum -y install nginx
systemctl enable nginx
openssl dhparam 2048 -out /etc/pki/tls/dhparam.pem

VER=$(cat /tmp/boxversion)
echo "nginx: ${VER}" >> /home/vagrant/boxversion

exit 0
