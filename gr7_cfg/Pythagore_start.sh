#!/bin/bash
ip -6 addr add fd00:300::7/48 dev belneta

ip addr add fd00:200:7:12::2/64 dev Pythagore-eth0
ip addr add fd00:200:7:25::2/64 dev Pythagore-eth1
ip addr add fd00:200:7:26::2/64 dev Pythagore-eth2

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

# echo "[PYTH] setting firewall"
# firewalls/./PYTH.sh
# echo "[PYTH] firewall set"
