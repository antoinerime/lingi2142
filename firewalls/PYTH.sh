#!/bin/bash

# Import subnet address for router/server, admin, staff and guest
. ADDRESS.sh

#
# -------- Initial configuration
#

# Erase all existing chain
ip6tables -F INPUT
ip6tables -F OUTPUT
ip6tables -F FORWARD
ip6tables -F

# Drop is the default policy
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

# Accept loopback access
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

# Accept already established or related connection
ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

#
# -------- Border configuration
#
# Accept bgp (port:179 over tcp) in/out traffic from interface belneta
ip6tables -A INPUT -i belneta -p tcp --dport 179 -j ACCEPT
ip6tables -A OUTPUT -o belneta -p tcp --dport 179 -j ACCEPT

# Block ospf (port:89) traffic from/to internet
ip6tables -A INPUT -i belneta -p 89 -j DROP
ip6tables -A OUTPUT -o belneta -p 89 -j DROP
ip6tables -A FORWARD -i belneta -p 89 -j DROP
ip6tables -A FORWARD -o belneta -p 89 -j DROP

# Block SSH (port:22 over tcp) connection from outside
ip6tables -A INPUT -i belneta -p tcp --dport 22 -j DROP

# Block HTTP/HTTPS (port:80,443 over tcp) request from outside
ip6tables -A INPUT -i belneta -p tcp -m multiport --dport 80,443 -j DROP

# Block DHCPv6 (port:546,547 over udp) from/to Internet
ip6tables -A INPUT -i belneta -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A OUTPUT -o belneta -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A FORWARD -i belneta -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A FORWARD -o belneta -p udp -m multiport --dports 546,547 -j DROP

# Block SSH (port:22 over tcp) connection from outside
ip6tables -A INPUT -i belnetb -p tcp --dport 22 -j DROP

#
# -------- ROUTER configuration
#

# Accept all the other ospf, they are comming from internet

# Accept ospf (port:89) from inside the Network
ip6tables -A INPUT -i Pythagore-eth0 -s $ROUT2 -p 89 -j ACCEPT
ip6tables -A INPUT -i Pythagore-eth0 -s $ROUT3 -p 89 -j ACCEPT
ip6tables -A INPUT -i Pythagore-eth1 -s $ROUT2 -p 89 -j ACCEPT
ip6tables -A INPUT -i Pythagore-eth1 -s $ROUT3 -p 89 -j ACCEPT
ip6tables -A INPUT -i Pythagore-eth2 -s $ROUT2 -p 89 -j ACCEPT
ip6tables -A INPUT -i Pythagore-eth2 -s $ROUT3 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth0 -d $ROUT2 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth0 -d $ROUT3 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth1 -d $ROUT2 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth1 -d $ROUT3 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth2 -d $ROUT2 -p 89 -j ACCEPT
ip6tables -A OUTPUT -o Pythagore-eth2 -d $ROUT3 -p 89 -j ACCEPT
## Forward rules concerning ospf
ip6tables -A FORWARD -i Pythagore-eth0 -s $ROUT2 -p 89 -j ACCEPT
ip6tables -A FORWARD -i Pythagore-eth0 -s $ROUT3 -p 89 -j ACCEPT
ip6tables -A FORWARD -i Pythagore-eth1 -s $ROUT2 -p 89 -j ACCEPT
ip6tables -A FORWARD -i Pythagore-eth1 -s $ROUT3 -p 89 -j ACCEPT
ip6tables -A FORWARD -i Pythagore-eth2 -s $ROUT2 -p 89 -j ACCEPT
ip6tables -A FORWARD -i Pythagore-eth2 -s $ROUT3 -p 89 -j ACCEPT
ip6tables -A FORWARD -o Pythagore-eth0 -s $ROUT2 -p 89 -j ACCEPT
ip6tables -A FORWARD -o Pythagore-eth0 -s $ROUT3 -p 89 -j ACCEPT
ip6tables -A FORWARD -o Pythagore-eth1 -s $ROUT2 -p 89 -j ACCEPT
ip6tables -A FORWARD -o Pythagore-eth1 -s $ROUT3 -p 89 -j ACCEPT
ip6tables -A FORWARD -o Pythagore-eth2 -s $ROUT2 -p 89 -j ACCEPT
ip6tables -A FORWARD -o Pythagore-eth2 -s $ROUT3 -p 89 -j ACCEPT

# Accept ICMPv6 only source for FORW to avoid capture of staff->router
ip6tables -A INPUT -p icmpv6 -s $ROUT2 -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 -d $ROUT2 -j ACCEPT
ip6tables -A FORWARD -p icmpv6 -s $ROUT2 -j ACCEPT
ip6tables -A INPUT -p icmpv6 -s $ROUT3 -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 -d $ROUT3 -j ACCEPT
ip6tables -A FORWARD -p icmpv6 -s $ROUT3 -j ACCEPT

#
# -------- ADMIN configuration
#

# Accept everything for/from administrators
ip6tables -A INPUT -s $ADMIN2 -j ACCEPT
ip6tables -A INPUT -s $ADMIN3 -j ACCEPT
ip6tables -A OUTPUT -d $ADMIN2 -j ACCEPT
ip6tables -A OUTPUT -d $ADMIN3 -j ACCEPT
ip6tables -A FORWARD -s $ADMIN2 -j ACCEPT
ip6tables -A FORWARD -s $ADMIN3 -j ACCEPT

#
# -------- STAFF configuration
#

#
# -------- GUEST configuration
#

#
# -------- IOT configuration
#

# Accept ICMPv6 (to be filtered: R, s,g)
# ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
# ip6tables -A OUTPUT -p ipv6-icmp -j ACCEPT
# ip6tables -A FORWARD -p ipv6-icmp -j ACCEPT
#
# Accept SSH connection (port:22) (to be filtered: A)
ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A FORWARD -p tcp --dport 22 -j ACCEPT

#LOG
ip6tables -A INPUT -j LOG --log-prefix "++ [INPUT] Packet dropped ++ "
ip6tables -A OUTPUT -j LOG --log-prefix "++ [OUTPUT] Packet dropped ++ "
ip6tables -A FORWARD -j LOG --log-prefix "++ [FORWARD] Packet dropped ++ "
# ip6tables-save
