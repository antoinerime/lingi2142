#!/bin/bash
ip -6 rule add from fd00:200:7::/48 table 200
ip -6 rule add from fd00:300:7::/48 table 300

ip addr add fd00:200:7:56::6/64 dev Stevin-eth0
ip addr add fd00:200:7:26::6/64 dev Stevin-eth1

ip addr add fd00:300:7:56::6/64 dev Stevin-eth0
ip addr add fd00:300:7:26::6/64 dev Stevin-eth1
puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

echo "[STEV] setting firewall"
firewalls/./INTERN.sh
echo "[STEV] firewall set"
