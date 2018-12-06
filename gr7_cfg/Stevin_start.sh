#!/bin/bash
# ip -6 rule add from fd00:200:7::/48 table 200
# ip -6 rule add from fd00:300:7::/48 table 300

ip addr add fd00:200:7:56::6/64 dev Stevin-eth0
ip addr add fd00:200:7:26::6/64 dev Stevin-eth1
ip addr add fd00:200:7:60::/64 dev Stevin-lan0
ip addr add fd00:200:7:1060::/64 dev Stevin-lan1
ip addr add fd00:200:7:2060::/64 dev Stevin-lan2
ip addr add fd00:200:7:3060::/64 dev Stevin-lan3
ip addr add fd00:200:7:4060::/64 dev Stevin-lan4

ip addr add fd00:300:7:56::6/64 dev Stevin-eth0
ip addr add fd00:300:7:26::6/64 dev Stevin-eth1
ip addr add fd00:300:7:60::/64 dev Stevin-lan0
ip addr add fd00:300:7:1060::/64 dev Stevin-lan1
ip addr add fd00:300:7:2060::/64 dev Stevin-lan2
ip addr add fd00:300:7:3060::/64 dev Stevin-lan3
ip addr add fd00:300:7:4060::/64 dev Stevin-lan4
puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

#echo "[STEV] setting firewall"
#firewalls/./STEV.sh
#echo "[STEV] firewall set"

radvd -C /etc/radvd.conf

dhcrelay -q -6 -l Stevin-lan0 -l Stevin-lan1 -l Stevin-lan2 -l Stevin-lan3 -l Stevin-lan4 -u fd00:200:7:2a::a%Stevin-eth0 -u fd00:200:7:2a::a%Stevin-eth1 -u fd00:300:7:2a::a%Stevin-eth0 -u fd00:300:7:2a::a%Stevin-eth1
