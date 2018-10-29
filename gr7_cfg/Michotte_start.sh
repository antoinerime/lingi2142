#!/bin/bash
# ip -6 rule add from fd00:200:7::/48 table 200
# ip -6 rule add from fd00:300:7::/48 table 300

ip addr add fd00:200:7:34::4/64 dev Michotte-eth0
ip addr add fd00:200:7:45::4/64 dev Michotte-eth1
ip addr add fd00:200:7:40::/64 dev Michotte-lan0
ip addr add fd00:200:7:1040::/64 dev Michotte-lan1
ip addr add fd00:200:7:2040::/64 dev Michotte-lan2
ip addr add fd00:200:7:3040::/64 dev Michotte-lan3
ip addr add fd00:200:7:4040::/64 dev Michotte-lan4

ip addr add fd00:300:7:34::4/64 dev Michotte-eth0
ip addr add fd00:300:7:45::4/64 dev Michotte-eth1
ip addr add fd00:300:7:40::/64 dev Michotte-lan0
ip addr add fd00:300:7:1040::/64 dev Michotte-lan1
ip addr add fd00:300:7:2040::/64 dev Michotte-lan2
ip addr add fd00:300:7:3040::/64 dev Michotte-lan3
ip addr add fd00:300:7:4040::/64 dev Michotte-lan4
puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

echo "[MICH] setting firewall"
firewalls/./MICH.sh
echo "[MICH] firewall set"
radvd -C /etc/radvd.conf

dhcrelay -q -6 -l Michotte-lan0 -l Michotte-lan1 -l Michotte-lan2 -l Michotte-lan3 -l Michotte-lan4 -u fd00:200:7:2a::a%Michotte-eth0 -u fd00:200:7:2a::a%Michotte-eth1 -u fd00:300:7:2a::a%Michotte-eth0 -u fd00:300:7:2a::a%Michotte-eth1
