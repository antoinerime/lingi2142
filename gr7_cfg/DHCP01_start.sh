#!/bin/bash

ip addr add fd00:200:7:2a::a/64 dev DHCP01-eth0
ip addr add fd00:300:7:2a::a/64 dev DHCP01-eth0

ip -6 route add default via fd00:200:7:2a::2

