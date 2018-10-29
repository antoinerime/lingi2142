#!/bin/bash

# ip -6 rule add from fd00:200:7::/48 table 200
# ip -6 rule add from fd00:300:7::/48 table 300

ip addr add fd00:200:7:45::5/64 dev Carnoy-eth0
ip addr add fd00:200:7:25::5/64 dev Carnoy-eth1
ip addr add fd00:200:7:56::5/64 dev Carnoy-eth2
ip addr add fd00:200:7:57::5/64 dev Carnoy-lan0
ip addr add fd00:200:7:59::5/64 dev Carnoy-lan0
ip addr add fd00:200:7:5a::5/64 dev Carnoy-lan0
ip addr add fd00:200:7:1050::/64 dev Carnoy-lan1
ip addr add fd00:200:7:2050::/64 dev Carnoy-lan2
ip addr add fd00:200:7:3050::/64 dev Carnoy-lan3
ip addr add fd00:200:7:4050::/64 dev Carnoy-lan4

ip addr add fd00:300:7:45::5/64 dev Carnoy-eth0
ip addr add fd00:300:7:25::5/64 dev Carnoy-eth1
ip addr add fd00:300:7:56::5/64 dev Carnoy-eth2
ip addr add fd00:300:7:57::5/64 dev Carnoy-lan0
ip addr add fd00:300:7:59::5/64 dev Carnoy-lan0
ip addr add fd00:300:7:5a::5/64 dev Carnoy-lan0
ip addr add fd00:300:7:1050::/64 dev Carnoy-lan1
ip addr add fd00:300:7:2050::/64 dev Carnoy-lan2
ip addr add fd00:300:7:3050::/64 dev Carnoy-lan3
ip addr add fd00:300:7:4050::/64 dev Carnoy-lan4

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

# echo "[CARN] setting firewall"
# firewalls/./INTERN.sh
# echo "[CARN] firewall set"

radvd -C /etc/radvd.conf

dhcrelay -q -6 -l Carnoy-lan0 -l Carnoy-lan1 -l Carnoy-lan2 -l Carnoy-lan3 -l Carnoy-lan4 -u fd00:200:7:2a::a%Carnoy-eth0 -u fd00:200:7:2a::a%Carnoy-eth1 -u fd00:200:7:2a::a%Carnoy-eth2 -u fd00:300:7:2a::a%Carnoy-eth0 -u fd00:300:7:2a::a%Carnoy-eth1 -u fd00:300:7:2a::a%Carnoy-eth2 -u fd00:200:7:5a::a%Carnoy-lan0 -u fd00:300:7:5a::a%Carnoy-lan0
