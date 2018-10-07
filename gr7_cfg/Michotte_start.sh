#!/bin/bash
ip addr add fd00:200:7:3::/64 dev Michotte-eth0
ip addr add fd00:200:7:3::/64 dev Michotte-eth1

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules
