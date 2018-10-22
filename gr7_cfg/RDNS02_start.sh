#!/bin/bash

ip addr add fd00:200:7:59::9/64 dev RDNS02-eth0
ip addr add fd00:300:7:59::9/64 dev RDNS02-eth0

ip -6 route add default via fd00:200:7:59::5

/usr/sbin/named
