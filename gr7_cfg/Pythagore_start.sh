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

ip addr add fd00:300:7:12::2/64 dev Pythagore-eth0
ip addr add fd00:300:7:25::2/64 dev Pythagore-eth1
ip addr add fd00:300:7:26::2/64 dev Pythagore-eth2
ip addr add fd00:300:7:27::2/64 dev Pythagore-lan0
ip addr add fd00:300:7:29::2/64 dev Pythagore-lan0

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

#Wait for ospf to converge
ip -6 route add default dev tun-Hal table 200
ip -6 route add default via fd00:300::b table 300
# echo "[PYTH] setting firewall"
# firewalls/./PYTH.sh
# echo "[PYTH] firewall set"

radvd -C /etc/radvd.conf
