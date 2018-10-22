#!/bin/bash

ip addr add fd00:200:7:29::9/64 dev RDNS01-eth0
ip addr add fd00:300:7:29::9/64 dev RDNS01-eth0

ip -6 route add default via fd00:200:7:29::2

/usr/sbin/named
