#!/bin/bash
echo "/usr/local/lib" >> /etc/ld.so.conf
/sbin/ldconfig
ldconfig

echo "start trackerd"
/etc/init.d/fdfs_trackerd start

echo "start storage"
/etc/init.d/fdfs_storaged start

echo "start openresty"
/usr/local/openresty/bin/openresty -g 'daemon off;'
