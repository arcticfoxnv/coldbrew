#!/bin/bash

set -ex

yum -y install git autoconf automake libtool libcurl-devel httpd-devel pcre-devel libxml2-devel openssl-devel

cd /tmp
git clone https://github.com/SpiderLabs/ModSecurity.git
cd ModSecurity
git checkout origin/nginx_refactoring
./autogen.sh && ./configure --disable-apache2-module --enable-standalone-module && make

cd /tmp
curl -O http://nginx.org/download/nginx-1.13.1.tar.gz
tar -zxf nginx-1.13.1.tar.gz
cd nginx-1.13.1
./configure --prefix=/opt/nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --add-module=../ModSecurity/nginx/modsecurity && make && sudo make install

cd /tmp
rm -rf ModSecurity nginx-1.13.1

git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /opt/owasp-crs
openssl dhparam 2048 -out /etc/pki/tls/dhparam.pem

cp /tmp/config/nginx.conf /opt/nginx/conf
cp /tmp/config/modsecurity.conf /opt/nginx/conf
cp /tmp/config/unicode.mapping /opt/nginx/conf
cp /tmp/config/crs-setup.conf /opt/owasp-crs
cp /tmp/config/nginx.service /lib/systemd/system/nginx.service
rename .example '' /opt/owasp-crs/rules/*.example
systemctl --system daemon-reload

rm -rf /tmp/*

VER=$(cat /tmp/boxversion)
echo "nginx+modsecurity: ${VER}" >> /home/vagrant/boxversion

exit 0
