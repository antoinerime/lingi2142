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
# -------- Router configuration + DNS Server
#
# Accept DHCP 
ip6tables -A INPUT -p udp -m multiport --dport 547,547 -j ACCEPT
ip6tables -A FORWARD -p udp -m multiport --dports 546,547 -j ACCEPT
ip6tables -A OUTPUT -p udp -m multiport --dports 546,547 -j ACCEPT

# Accept ICMPv6
ip6tables -A INPUT -p icmpv6 -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 -j ACCEPT
ip6tables -A FORWARD -p icmpv6 -j ACCEPT

# Accept ospf (port:89) from inside the Network
ip6tables -A INPUT -p 89 -j ACCEPT
ip6tables -A OUTPUT -p 89 -j ACCEPT
ip6tables -A FORWARD -p 89 -j ACCEPT

# Accept incomming and outgoing packet for DNS
ip6tables -A INPUT -p tcp --dport 53 -s $SUB2 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 53 -d $SUB2 -j ACCEPT
ip6tables -A FORWARD -p tcp --dport 53 -d $SUB2 -j ACCEPT
ip6tables -A INPUT -p tcp --dport 53 -s $SUB3 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 53 -d $SUB3 -j ACCEPT
ip6tables -A FORWARD -p tcp --dport 53 -d $SUB3 -j ACCEPT

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
# Accept tcp : send dns request to dns server, send to 80/443 and ssh
ip6tables -A FORWARD --src $STAFF2 -p tcp -m multiport --dports 22,53,80,443 -j ACCEPT
ip6tables -A FORWARD --src $STAFF3 -p tcp -m multiport --dports 22,53,80,443 -j ACCEPT

#
# -------- GUEST configuration
#
# Accept tcp : send dns , http/https
ip6tables -A FORWARD --src $GUEST2 -p tcp -m multiport --dports 53,80,443 -j ACCEPT
ip6tables -A FORWARD --src $GUEST3 -p tcp -m multiport --dports 53,80,443 -j ACCEPT

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
ip6tables -A INPUT -j NFLOG --nflog-prefix "++ [INPUT] Packet dropped ++ "
ip6tables -A OUTPUT -j NFLOG --nflog-prefix "++ [OUTPUT] Packet dropped ++ "
ip6tables -A FORWARD -j NFLOG --nflog-prefix "++ [FORWARD] Packet dropped ++ "
# ip6tables-save
