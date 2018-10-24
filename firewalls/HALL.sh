#!/bin/bash

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
# -------- Border configuration
#
# Accept bgp (port:179 over tcp) in/out traffic from interface belnetb
ip6tables -A INPUT -i belnetb -p tcp --dport 179 -j ACCEPT
ip6tables -A OUTPUT -o belnetb -p tcp --dport 179 -j ACCEPT

# Block ospf (port:89) traffic from/to internet
ip6tables -A INPUT -i belnetb -p 89 -j DROP
ip6tables -A OUTPUT -o belnetb -p 89 -j DROP
ip6tables -A FORWARD -i belnetb -p 89 -j DROP
ip6tables -A FORWARD -o belnetb -p 89 -j DROP

# Block HTTP/HTTPS (port:80,443 over tcp) request from outside
ip6tables -A INPUT -i belnetb -p tcp -m multiport --dport 80,443 -j DROP

# Block DHCPv6 (port:546,547 over udp) from/to Internet
ip6tables -A INPUT -i belnetb -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A OUTPUT -o belnetb -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A FORWARD -i belnetb -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A FORWARD -o belnetb -p udp -m multiport --dports 546,547 -j DROP

# Block SSH (port:22 over tcp) connection from outside
ip6tables -A INPUT -i belnetb -p tcp --dport 22 -j DROP

#
# -------- ROUTER configuration
#
# Accept ICMPv6
ip6tables -A INPUT -p icmpv6 -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 -j ACCEPT
ip6tables -A FORWARD -p icmpv6 -j ACCEPT

# Accept ospf (port:89) from inside the Network
ip6tables -A INPUT -p 89 -j ACCEPT
ip6tables -A OUTPUT -p 89 -j ACCEPT
ip6tables -A FORWARD -p 89 -j ACCEPT

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
# Accept SNMP  protocol (experimental)
ip6tables -A INPUT -p udp --dport 161 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 161 -j ACCEPT
ip6tables -A FORWARD -p udp --dport 161 -j ACCEPT

# Accept SSH connection (port:22) default
ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A FORWARD -p tcp --dport 22 -j ACCEPT

#LOG
ip6tables -A INPUT -j NFLOG --nflog-prefix "++ [INPUT] Packet dropped ++ "
ip6tables -A OUTPUT -j NFLOG --nflog-prefix "++ [OUTPUT] Packet dropped ++ "
ip6tables -A FORWARD -j NFLOG --nflog-prefix "++ [FORWARD] Packet dropped ++ "
# ip6tables-save
