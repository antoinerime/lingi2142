#!/bin/bash

ip addr add fd00:200:7:57::7/64 dev ADNS02-eth0
ip addr add fd00:300:7:57::7/64 dev ADNS02-eth0

ip -6 route add default via fd00:200:7:57::5

/usr/sbin/named
