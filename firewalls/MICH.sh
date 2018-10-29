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
# -------- Router configuration
#

#Accept Tunnel protocol
ip6tables -A FORWARD -s fd00:200:7:11::1 -d fd00:200:7:22::2 -j ACCEPT
ip6tbales -A FORWARD -s fd00:200:7:22::2 -d fd00:200:7:11::1 -j ACCEP

# Accept DHCP
ip6tables -A INPUT -p udp -m multiport --dport 547,547 -j ACCEPT
ip6tables -A FORWARD -p udp -m multiport --dports 546,547 -j ACCEPT
ip6tables -A OUTPUT -p udp -m multiport --dports 546,547 -j ACCEPT
ip6tables -A INPUT -p tcp -m multiport --dport 547,547 -j ACCEPT
ip6tables -A FORWARD -p tcp -m multiport --dports 546,547 -j ACCEPT
ip6tables -A OUTPUT -p tcp -m multiport --dports 546,547 -j ACCEPT

# Accept ICMPv6
ip6tables -A INPUT -p icmpv6 -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 -j ACCEPT
ip6tables -A FORWARD -p icmpv6 -j ACCEPT

# Accept ospf (port:89) from inside the Network
ip6tables -A INPUT -p 89 -j ACCEPT
ip6tables -A OUTPUT -p 89 -j ACCEPT
ip6tables -A FORWARD -p 89 -j ACCEPT

# Accept Forwarding DNS queries/answers
ip6tables -A FORWARD -d $SUB2 -p tcp --dport 53 -j ACCEPT
ip6tables -A FORWARD -d $SUB3 -p tcp --dport 53 -j ACCEPT

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
# Drop forwarding ssh/dns/http/https packet from staff to staff
ip6tables -A FORWARD -s $STAFF2  -d $STAFF2 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF2  -d $STAFF3 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $STAFF2 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $STAFF3 -p tcp -m multiport --dports 22,53,80,443 -j DROP
# Drop forwarding ssh/dns/http/https packet from staff to guest
ip6tables -A FORWARD -s $STAFF2  -d $GUEST2 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF2  -d $GUEST3 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $GUEST2 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $GUEST3 -p tcp -m multiport --dports 22,53,80,443 -j DROP
# Accept forwarding ssh/dns/http/https packet from staff
ip6tables -A FORWARD -s $STAFF2 -p tcp -m multiport --dports 22,53,80,443 -j ACCEPT
ip6tables -A FORWARD -s $STAFF3 -p tcp -m multiport --dports 22,53,80,443 -j ACCEPT

#
# -------- GUEST configuration
#
# Drop forwarding ssh/dns/http/https packet from guest to staff
ip6tables -A FORWARD -s $GUEST2  -d $STAFF2 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST2  -d $STAFF3 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $STAFF2 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $STAFF3 -p tcp -m multiport --dports 22,53,80,443 -j DROP
# Drop forwarding ssh/dns/http/https packet from guest to guest
ip6tables -A FORWARD -s $GUEST2  -d $GUEST2 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST2  -d $GUEST3 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $GUEST2 -p tcp -m multiport --dports 22,53,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $GUEST3 -p tcp -m multiport --dports 22,53,80,443 -j DROP
# Accept tcp : send dns , http/https
ip6tables -A FORWARD --src $GUEST2 -p tcp -m multiport --dports 53,80,443 -j ACCEPT
ip6tables -A FORWARD --src $GUEST3 -p tcp -m multiport --dports 53,80,443 -j ACCEPT

#
# -------- IOT configuration
#
# Accept staff to send print job to a remote printer
ip6tables -A FORWARD --src $STAFF2 -p tcp --dport 515 -j ACCEPT
ip6tables -A FORWARD --src $STAFF3 -p tcp --dport 515 -j ACCEPT

# Accept SNMP  protocol
ip6tables -A INPUT -p udp --dport 161 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 161 -j ACCEPT
ip6tables -A FORWARD -p udp --dport 161 -j ACCEPT

# Log
ip6tables -A INPUT -j LOG
ip6tables -A OUTPUT -j LOG
ip6tables -A FORWARD -j LOG
