#!/bin/bash

# ip -6 rule add from fd00:200:7::/48 table 200
# ip -6 rule add from fd00:300:7::/48 table 300

ip addr add fd00:200:7:45::5/64 dev Carnoy-eth0
ip addr add fd00:200:7:25::5/64 dev Carnoy-eth1
ip addr add fd00:200:7:56::5/64 dev Carnoy-eth2
ip addr add fd00:200:7:57::5/64 dev Carnoy-lan0
ip addr add fd00:200:7:59::5/64 dev Carnoy-lan0

ip addr add fd00:300:7:45::5/64 dev Carnoy-eth0
ip addr add fd00:300:7:25::5/64 dev Carnoy-eth1
ip addr add fd00:300:7:56::5/64 dev Carnoy-eth2
ip addr add fd00:300:7:57::5/64 dev Carnoy-lan0
ip addr add fd00:300:7:59::5/64 dev Carnoy-lan0

puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules

# echo "[CARN] setting firewall"
# firewalls/./INTERN.sh
# echo "[CARN] firewall set"

radvd -C /etc/radvd.conf
