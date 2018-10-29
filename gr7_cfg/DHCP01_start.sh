#!/bin/bash

ip addr add fd00:200:7:2a::a/64 dev DHCP01-eth0
ip addr add fd00:300:7:2a::a/64 dev DHCP01-eth0

ip -6 route add default via fd00:200:7:2a::2

/usr/sbin/dhcpd -6 -cf /etc/dhcp/dhcpd6.conf -lf /etc/dhcp/dhcpd6.leases DHCP01-eth0
