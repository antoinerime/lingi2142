#!/bin/bash
ip addr add fd00:200:7:56::0/64 dev Stevin-eth0
ip addr add fd00:200:7:26::1/64 dev Stevin-eth1

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules
