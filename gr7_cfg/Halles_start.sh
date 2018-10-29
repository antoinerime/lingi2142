#!/bin/bash
ip -6 rule add from fd00:200:7::/48 to fd00:200:7::/48 table main priority 100
ip -6 rule add from fd00:200:7::/48 to fd00:300:7::/48 table main priority 100
ip -6 rule add from fd00:300:7::/48 to fd00:300:7::/48 table main priority 100
ip -6 rule add from fd00:300:7::/48 to fd00:200:7::/48 table main priority 100

#Set up tunnel between Pythaogre and Halles
ip -6 tunnel add tun-Pyth mode ip6ip6 remote fd00:200:7:22::2 local fd00:200:7:11::1
ip link set dev tun-Pyth up
ip -6 addr add fd00:200:7:11::1 dev tun-Pyth


ip -6 rule add from fd00:200:7::/48 table 200
ip -6 rule add from fd00:300:7::/48 table 300

ip -6 addr add fd00:200::7/48 dev belnetb

ip addr add fd00:200:7:13::1/64 dev Halles-eth0
ip addr add fd00:200:7:12::1/64 dev Halles-eth1

ip addr add fd00:300:7:13::1/64 dev Halles-eth0
ip addr add fd00:300:7:12::1/64 dev Halles-eth1

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

#Wait for ospf to converge
ip -6 route add default via fd00:200::b table 200
ip -6 route add default dev tun-Pyth table 300
# echo "[HALL] setting firewall"
# firewalls/./HALL.sh
# echo "[HALL] firewall set"
radvd -C /etc/radvd.conf

dhcrelay -q -6 -l Halles-lan0 -u fd00:200:7:2a::a%Halles-eth0 -u fd00:200:7:2a::a%Halles-eth1 -u fd00:300:7:2a::a%Halles-eth0 -u fd00:300:7:2a::a%Halles-eth1
