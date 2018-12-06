#!/bin/bash
# ip -6 rule add from fd00:200:7::/48 table 200
# ip -6 rule add from fd00:300:7::/48 table 300

ip addr add fd00:200:7:34::3/64 dev SH1C-eth0
ip addr add fd00:200:7:13::3/64 dev SH1C-eth1
ip addr add fd00:200:7:30::/64 dev SH1C-lan0
ip addr add fd00:200:7:1030::/64 dev SH1C-lan1
ip addr add fd00:200:7:2030::/64 dev SH1C-lan2
ip addr add fd00:200:7:3030::/64 dev SH1C-lan3
ip addr add fd00:200:7:4030::/64 dev SH1C-lan4

ip addr add fd00:300:7:34::3/64 dev SH1C-eth0
ip addr add fd00:300:7:13::3/64 dev SH1C-eth1
ip addr add fd00:300:7:30::/64 dev SH1C-lan0
ip addr add fd00:300:7:1030::/64 dev SH1C-lan1
ip addr add fd00:300:7:2030::/64 dev SH1C-lan2
ip addr add fd00:300:7:3030::/64 dev SH1C-lan3
ip addr add fd00:300:7:4030::/64 dev SH1C-lan4

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

#echo "[SH1C] setting firewall"
#firewalls/./SH1C.sh
#echo "[SH1C] firewall set"

radvd -C /etc/radvd.conf

dhcrelay -q -6 -l SH1C-lan0 -l SH1C-lan1 -l SH1C-lan2 -l SH1C-lan3 -l SH1C-lan4 -u fd00:200:7:2a::a%SH1C-eth0 -u fd00:200:7:2a::a%SH1C-eth1 -u fd00:300:7:2a::a%SH1C-eth0 -u fd00:300:7:2a::a%SH1C-eth1
