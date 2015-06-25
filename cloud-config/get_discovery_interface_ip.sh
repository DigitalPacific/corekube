#!/bin/bash
# Get's the IP of the interface that discovery will be
# accessible over
DISCOVERY_IF=%discovery_net_interface%
/usr/bin/ip -4 addr show $DISCOVERY_IF | /usr/bin/awk '/inet/ {print $2}' | /usr/bin/cut -d/ -f1 > /run/IP
/usr/bin/sed -i 's/^/IP=/' /run/IP