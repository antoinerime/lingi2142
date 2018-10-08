#!/bin/bash
ip -6 addr add fd00:200::7/48 dev belnetb

ip addr add fd00:200:7:00::/64 dev Halles-eth0
ip addr add fd00:200:7:01::/64 dev Halles-eth1

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules
