#!/bin/bash

ENV="/etc/environment"

# Test for RW access to $1
touch $ENV
if [ $? -ne 0 ]; then
    echo exiting, unable to modify: $ENV
    exit 1
fi

# Setup environment target
sed -i -e '/^COREOS_PUBLIC_IPV4=/d' \
    -e '/^COREOS_PRIVATE_IPV4=/d' \
    "${ENV}"

# We spin loop until the the IP addresses are set
function get_ip () {
    IF=$1
    IP=
    while [ 1 ]; do
        IP=$(ifconfig $IF | awk '/inet / {print $2}')
        if [ "$IP" != "" ]; then
            break
        fi
        sleep .1
    done
    echo $IP
}

# Echo results of IP queries to environment file as soon as network interfaces
# get assigned IPs
echo COREOS_PUBLIC_IPV4=$(get_ip eth0) >> $ENV # Also assigned to same IP
echo COREOS_PRIVATE_IPV4=$(get_ip eth0) >> $ENV #eno1 should be changed to your device name
A=`cat /etc/environment | grep COREOS_PRIVATE_IPV4 | cut -f2 -d "="`
sed -i "s#=:#=${A}:#g" /run/systemd/system/etcd.service.d/20-cloudinit.conf
systemctl daemon-reload

