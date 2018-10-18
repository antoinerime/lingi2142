#!/bin/bash

ip route add default via fd00:200:7:12::1 table T2
ip route add default via fd00:300::b table T3


ip -6 rule add from fd00:200:7::/48 table T2
ip -6 rule add from fd00:300:7::/48 table T3

ip -6 addr add fd00:300::7/48 dev belneta

ip addr add fd00:200:7:21::0/64 dev Pythagore-eth0
ip addr add fd00:200:7:25::1/64 dev Pythagore-eth1
ip addr add fd00:200:7:26::2/64 dev Pythagore-eth2

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules
