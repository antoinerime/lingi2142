#!/bin/bash
ip addr add fd00:200:7:40::/64 dev Carnoy-eth0
ip addr add fd00:200:7:41::/64 dev Carnoy-eth1
ip addr add fd00:200:7:42::/64 dev Carnoy-eth2

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules
