#!/bin/bash
# FOR SH1C MICH CARN STEV
# Import subnet address for router/server, admin, staff and guest
. firewalls/ADDRESS.sh

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
# -------- Router configuration
#

# Accept ICMPv6
ip6tables -A INPUT -p icmpv6 -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 -j ACCEPT
ip6tables -A FORWARD -p icmpv6 -j ACCEPT

# Accept OSPF (port:89) (to be filtered: R)
ip6tables -A INPUT -p 89 -s $ROUT2 -j ACCEPT
ip6tables -A OUTPUT -p 89 -d $ROUT2 -j ACCEPT
ip6tables -A FORWARD -p 89 -s $ROUT2 -j ACCEPT
ip6tables -A INPUT -p 89 -s $ROUT3 -j ACCEPT
ip6tables -A OUTPUT -p 89 -d $ROUT3 -j ACCEPT
ip6tables -A FORWARD -p 89 -s $ROUT3 -j ACCEPT

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

# Accept SSH connection (port:22) (to be filtered: A)
ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A FORWARD -p tcp --dport 22 -j ACCEPT

# Accept SNMP  protocol (experimental)
ip6tables -A INPUT -p udp --dport 161 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 161 -j ACCEPT
ip6tables -A FORWARD -p udp --dport 161 -j ACCEPT

# Log
ip6tables -A INPUT -j LOG --log-prefix "++ [INPUT] Packet dropped ++ "
ip6tables -A OUTPUT -j LOG --log-prefix "++ [OUTPUT] Packet dropped ++ "
ip6tables -A FORWARD -j LOG --log-prefix "++ [FORWARD] Packet dropped ++ "
# ip6tables-save
