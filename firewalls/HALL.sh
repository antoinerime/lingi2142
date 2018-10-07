#!/bin/bash

# Version supporting only BGP, OSPF & HTTP/HTTPS, DHCP, SSH from outside

# Useful variables eth0 from PYTH & eth1 from SH1C
# Static address | Must automatize ip access
PYTH2="fe80::cce4:4ff:fef1:481"
PYTH3="fe80::cce4:4ff:fef1:481"
SH1C2="fe80::f0c3:aeff:fe14:f734"
SH1C3="fe80::f0c3:aeff:fe14:f734"

# Erase all existing chain
ip6tables -F INPUT
ip6tables -F OUTPUT
ip6tables -F FORWARD
ip6tables -F

# Accept bgp (port:179 over tcp) in/out traffic from interface belneta
ip6tables -A INPUT -i belnetb -p tcp --dport 179 -j ACCEPT
ip6tables -A OUTPUT -o belnetb -p tcp --dport 179 -j ACCEPT

# Block ospf (port:89) traffic from/to internet
ip6tables -A INPUT -i belnetb -p 89 -j DROP
ip6tables -A OUTPUT -o belnetb -p 89 -j DROP
ip6tables -A FORWARD -i belnetb -p 89 -j DROP

# Accept ospf (port:89) from inside the Network
ip6tables -A INPUT -i Halles-eth0 -s $SH1C2 -p 89 -j ACCEPT
ip6tables -A INPUT -i Halles-eth0 -s $SH1C3 -p 89 -j ACCEPT
ip6tables -A INPUT -i Halles-eth1 -s $PYTH2 -p 89 -j ACCEPT
ip6tables -A INPUT -i Halles-eth1 -s $PYTH3 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Halles-eth0 -d $SH1C2 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Halles-eth0 -d $SH1C3 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Halles-eth1 -d $PYTH2 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Halles-eth1 -d $PYTH3 -p 89 -j ACCEPT

# Block SSH (port:22 over tcp) connection from outside
ip6tables -A INPUT -i belnetb -p tcp --dport 22 -j DROP

# Block HTTP/HTTPS (port:80,443 over tcp) request from outside
ip6tables -A INPUT -i belnetb -p tcp -m multiport --dport 80,443 -j DROP

# Block DHCPv6 (port:546,547 over udp) from/to Internet
ip6tables -A INPUT -i belnetb -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A OUTPUT -o belnetb -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A FORWARD -i belnetb -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A FORWARD -o belnetb -p udp -m multiport --dports 546,547 -j DROP
