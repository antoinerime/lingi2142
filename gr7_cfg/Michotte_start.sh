#!/bin/bash
ip -6 rule add from fd00:200:7::/48 table 200
ip -6 rule add from fd00:300:7::/48 table 300

ip addr add fd00:200:7:34::4/64 dev Michotte-eth0
ip addr add fd00:200:7:45::4/64 dev Michotte-eth1

ip addr add fd00:300:7:34::4/64 dev Michotte-eth0
ip addr add fd00:300:7:45::4/64 dev Michotte-eth1
puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

echo "[MICH] setting firewall"
firewalls/./MICH.sh
ulogd -d
echo "[MICH] firewall set"
