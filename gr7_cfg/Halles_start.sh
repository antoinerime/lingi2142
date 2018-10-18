#!/bin/bash

#ip route add fd00:200:7::/48 dev belnetb src fd00:200::7 table T200
ip route add default via fd00:200::b table T200

ip route add default via fd00:300:12::2 table T300



ip -6 rule add from fd00:200:7::/48 table T200
ip -6 rule add from fd00:300:7::/48 table T300

ip -6 addr add fd00:200::7/48 dev belnetb

ip addr add fd00:200:7:13::0/64 dev Halles-eth0
ip addr add fd00:200:7:12::1/64 dev Halles-eth1

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules
