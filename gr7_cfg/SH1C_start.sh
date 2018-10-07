#!/bin/bash
ip addr add fd00:200:7:2::/48 dev SH1C-eth0
ip addr add fd00:200:7:2::/48 dev SH1C-eth1

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules
