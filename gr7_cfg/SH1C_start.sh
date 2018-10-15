#!/bin/bash
ip addr add fd00:200:7:34::3/64 dev SH1C-eth0
ip addr add fd00:200:7:13::3/64 dev SH1C-eth1

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

echo "[SH1C] setting firewall"
firewalls/./INTERN.sh
echo "[SH1C] firewall set"
