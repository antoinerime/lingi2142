#!/bin/bash
ip -6 addr add fd00:200::7/48 dev belnetb
puppet apply --verbose --parser future --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/site.pp --modulepath=/puppetmodules
