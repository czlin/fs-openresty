#!/bin/bash
mkdir -p /www/scratch-assets/upload_assets/internalapi/asset/
mkdir -p /www/scratch-assets/origin_assets/internalapi/asset/
mkdir -p $1
mkdir -p /www/thumb

chmod 777 -R /www/
chmod +x /www/fastdfs.sh

echo "/usr/local/lib" >> /etc/ld.so.conf
/sbin/ldconfig
ldconfig

echo "start trackerd"
/etc/init.d/fdfs_trackerd start

echo "start storage"
/etc/init.d/fdfs_storaged start

echo "start openresty"
/usr/local/openresty/bin/openresty -g 'daemon off;'
