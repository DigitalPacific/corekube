#!/bin/bash
# Sets up environment file with the discovery node's IP &
# port so # that in Overlode's template 
# master-apiserver@.service it can be passed 
# in as an argument 
/usr/bin/cat /run/systemd/system/etcd.service.d/20-cloudinit.conf | /usr/bin/grep -i discovery | /usr/bin/cut -f3 -d"=" | /usr/bin/awk -F '/v' '{print $1}' > /run/discovery_ip_port
/usr/bin/sed -i 's/^/DISCOVERY_IP_PORT=/' /run/discovery_ip_port