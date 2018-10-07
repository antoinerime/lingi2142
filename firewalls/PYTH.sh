#!/bin/bash

# Version supporting only BGP, OSPF & HTTP/HTTPS, DHCP, SSH from outside

# Useful variables eth1 from HALL & eth1 from CARN & eth1 from STEV
# Static address | Must automatize ip access
HALL2="fe80::bc47:b4ff:fe61:b3b9"
HALL3="fe80::bc47:b4ff:fe61:b3b9"
CARN2="fe80::1cbe:70ff:fe50:3755"
CARN3="fe80::1cbe:70ff:fe50:3755"
STEV2="fe80::1036:25ff:fe7e:2bac"
STEV3="fe80::1036:25ff:fe7e:2bac"

# Erase all existing chain
ip6tables -F INPUT
ip6tables -F OUTPUT
ip6tables -F FORWARD
ip6tables -F

# Accept bgp (port:179 over tcp) in/out traffic from interface belneta
ip6tables -A INPUT -i belneta -p tcp --dport 179 -j ACCEPT
ip6tables -A OUTPUT -o belneta -p tcp --dport 179 -j ACCEPT

# Block ospf (port:89) traffic from/to internet
ip6tables -A INPUT -i belneta -p 89 -j DROP
ip6tables -A OUTPUT -o belneta -p 89 -j DROP
ip6tables -A FORWARD -i belneta -p 89 -j DROP

# Accept ospf (port:89) from inside the Network
ip6tables -A INPUT -i Pythagore-eth0 -s $HALL2 -p 89 -j ACCEPT
ip6tables -A INPUT -i Pythagore-eth0 -s $HALL3 -p 89 -j ACCEPT
ip6tables -A INPUT -i Pythagore-eth1 -s $CARN2 -p 89 -j ACCEPT
ip6tables -A INPUT -i Pythagore-eth1 -s $CARN3 -p 89 -j ACCEPT
ip6tables -A INPUT -i Pythagore-eth2 -s $STEV2 -p 89 -j ACCEPT
ip6tables -A INPUT -i Pythagore-eth2 -s $STEV3 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth0 -d $HALL2 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth0 -d $HALL3 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth1 -d $CARN2 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth1 -d $CARN3 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth2 -d $STEV2 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth2 -d $STEV3 -p 89 -j ACCEPT

# Block SSH (port:22 over tcp) connection from outside
ip6tables -A INPUT -i belneta -p tcp --dport 22 -j DROP

# Block HTTP/HTTPS (port:80,443 over tcp) request from outside
ip6tables -A INPUT -i belneta -p tcp -m multiport --dport 80,443 -j DROP

# Block DHCPv6 (port:546,547 over udp) from/to Internet
ip6tables -A INPUT -i belneta -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A OUTPUT -o belneta -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A FORWARD -i belneta -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A FORWARD -o belneta -p udp -m multiport --dports 546,547 -j DROP
