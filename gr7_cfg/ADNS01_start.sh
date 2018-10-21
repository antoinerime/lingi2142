#!/bin/bash

ip addr add fd00:200:7:27::7/64 dev ADNS01-eth0
ip addr add fd00:300:7:29::7/64 dev ADNS01-eth0

ip -6 route add default via fd00:200:7:27::2

/usr/sbin/named
