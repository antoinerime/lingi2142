#!/bin/bash
ip -6 rule add from fd00:200:7::/48 to fd00:200:7::/48 table main priority 100
ip -6 rule add from fd00:200:7::/48 to fd00:300:7::/48 table main priority 100
ip -6 rule add from fd00:300:7::/48 to fd00:300:7::/48 table main priority 100
ip -6 rule add from fd00:300:7::/48 to fd00:200:7::/48 table main priority 100


ip -6 rule add from fd00:200:7::/48 table 200 priority 200
ip -6 rule add from fd00:300:7::/48 table 300 priority 200

ip -6 addr add fd00:300::7/48 dev belneta

ip addr add fd00:200:7:12::2/64 dev Pythagore-eth0
ip addr add fd00:200:7:25::2/64 dev Pythagore-eth1
ip addr add fd00:200:7:26::2/64 dev Pythagore-eth2
ip addr add fd00:200:7:29::2/64 dev Pythagore-lan0

ip addr add fd00:300:7:12::2/64 dev Pythagore-eth0
ip addr add fd00:300:7:25::2/64 dev Pythagore-eth1
ip addr add fd00:300:7:26::2/64 dev Pythagore-eth2
ip addr add fd00:300:7:29::2/64 dev Pythagore-lan0

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

#Wait for ospf to converge
ip route add default via fd00:200:7:12::1 table 200
ip route add default via fd00:300::b table 300
# echo "[PYTH] setting firewall"
# firewalls/./PYTH.sh
# echo "[PYTH] firewall set"
