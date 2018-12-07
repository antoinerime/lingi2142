#!/bin/bash
ip -6 rule add from fd00:200:7::/48 to fd00:200:7::/48 table main priority 100
ip -6 rule add from fd00:200:7::/48 to fd00:300:7::/48 table main priority 100
ip -6 rule add from fd00:300:7::/48 to fd00:300:7::/48 table main priority 100
ip -6 rule add from fd00:300:7::/48 to fd00:200:7::/48 table main priority 100

#Set up tunnel between Pythaogre and Halles
ip -6 tunnel add tun-Hal mode ip6ip6 remote fd00:200:7:11::1 local fd00:200:7:22::2
ip link set dev tun-Hal up
ip -6 addr add fd00:200:7:22::2 dev tun-Hal

ip -6 rule add from fd00:200:7::/48 table 200 priority 200
ip -6 rule add from fd00:300:7::/48 table 300 priority 200

ip -6 addr add fd00:300::7/48 dev belneta

ip addr add fd00:200:7:12::2/64 dev Pythagore-eth0
ip addr add fd00:200:7:25::2/64 dev Pythagore-eth1
ip addr add fd00:200:7:26::2/64 dev Pythagore-eth2
ip addr add fd00:200:7:27::2/64 dev Pythagore-lan0
ip addr add fd00:200:7:29::2/64 dev Pythagore-lan0
ip addr add fd00:200:7:2a::2/64 dev Pythagore-lan0
ip addr add fd00:200:7:1020::/64 dev Pythagore-lan1
ip addr add fd00:200:7:2020::/64 dev Pythagore-lan2
ip addr add fd00:200:7:3020::/64 dev Pythagore-lan3
ip addr add fd00:200:7:4020::/64 dev Pythagore-lan4

ip addr add fd00:300:7:12::2/64 dev Pythagore-eth0
ip addr add fd00:300:7:25::2/64 dev Pythagore-eth1
ip addr add fd00:300:7:26::2/64 dev Pythagore-eth2
ip addr add fd00:300:7:27::2/64 dev Pythagore-lan0
ip addr add fd00:300:7:29::2/64 dev Pythagore-lan0
ip addr add fd00:300:7:2a::2/64 dev Pythagore-lan0
ip addr add fd00:300:7:1020::/64 dev Pythagore-lan1
ip addr add fd00:300:7:2020::/64 dev Pythagore-lan2
ip addr add fd00:300:7:3020::/64 dev Pythagore-lan3
ip addr add fd00:300:7:4020::/64 dev Pythagore-lan4

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

#Wait for ospf to converge
ip -6 route add default dev tun-Hal table 200
ip -6 route add default via fd00:300::b table 300

echo "[PYTH] setting firewall"
firewalls/./PYTH.sh
echo "[PYTH] firewall set"

radvd -C /etc/radvd.conf

dhcrelay -q -6 -l Pythagore-lan0 -l Pythagore-lan1 -l Pythagore-lan2 -l Pythagore-lan3 -l Pythagore-lan4 -u fd00:200:7:5a::a%Pythagore-eth0 -u fd00:200:7:5a::a%Pythagore-eth1 -u fd00:200:7:5a::a%Pythagore-eth2 -u fd00:300:7:5a::a%Pythagore-eth0 -u fd00:300:7:5a::a%Pythagore-eth1 -u fd00:300:7:5a::a%Pythagore-eth2 -u fd00:200:7:2a::a%Pythagore-lan0 -u fd00:300:7:2a::a%Pythagore-lan0
