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
# -------- Tunnel configuration
#

#Accept Tunnel protocol
ip6tables  -A INPUT -p 41 -j ACCEPT
ip6tables  -A FORWARD -p 41 -j ACCEPT
ip6tables  -A OUTPUT -p 41 -j ACCEPT
ip6tables -A FORWARD -s fd00:200:7:11::1 -d fd00:200:7:22::2 -j ACCEPT
ip6tables -A FORWARD -s fd00:200:7:22::2 -d fd00:200:7:11::1 -j ACCEPT
ip6tables -A INPUT -s fd00:200:7:11::1 -d fd00:200:7:22::2 -j ACCEPT
ip6tables -A OUTPUT -d fd00:200:7:11::1 -j ACCEPT

#
# -------- Border configuration
#

# Block spoofed address from internet interface
ip6tables -A INPUT -i belneta -s $SUB2 -j DROP
ip6tables -A FORWARD -i belneta -s $SUB2 -j DROP
ip6tables -A INPUT -i belneta -s $SUB3 -j DROP
ip6tables -A FORWARD -i belneta -s $SUB3 -j DROP

# Accept bgp (port:179 over tcp) in/out traffic from interface belneta
ip6tables -A INPUT -i belneta -p tcp --dport 179 -j ACCEPT
ip6tables -A OUTPUT -o belneta -p tcp --dport 179 -j ACCEPT

# Block ospf (port:89) traffic from/to internet
ip6tables -A INPUT -i belneta -p 89 -j DROP
ip6tables -A OUTPUT -o belneta -p 89 -j DROP
ip6tables -A FORWARD -i belneta -p 89 -j DROP
ip6tables -A FORWARD -o belneta -p 89 -j DROP

# Block HTTP/HTTPS (port:80,443 over tcp) request from outside
ip6tables -A INPUT -i belneta -p tcp -m multiport --dports 80,443 -j REJECT

# Block DHCPv6 (port:546,547 over udp) from/to Internet
ip6tables -A INPUT -i belneta -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A OUTPUT -o belneta -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A FORWARD -i belneta -p udp -m multiport --dports 546,547 -j DROP
ip6tables -A FORWARD -o belneta -p udp -m multiport --dports 546,547 -j DROP

#
# -------- ROUTER configuration + DNS Server
#

# Accept DHCP
ip6tables -A INPUT -p udp -m multiport --dports 546,547 -j ACCEPT
ip6tables -A FORWARD -p udp -m multiport --dports 546,547 -j ACCEPT
ip6tables -A OUTPUT -p udp -m multiport --dports 546,547 -j ACCEPT
ip6tables -A INPUT -p tcp -m multiport --dports 546,547 -j ACCEPT
ip6tables -A FORWARD -p tcp -m multiport --dports 546,547 -j ACCEPT
ip6tables -A OUTPUT -p tcp -m multiport --dports 546,547 -j ACCEPT

# Accept ospf (port:89) from inside the Network
ip6tables -A INPUT -p 89 -j ACCEPT
ip6tables -A OUTPUT -p 89 -j ACCEPT
ip6tables -A FORWARD -p 89 -j ACCEPT

# Accept forwarding, incomming and outgoing packet for DNS (router is DNS serv)
ip6tables -A INPUT -p udp --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 53 -j ACCEPT

#
# -------- ADMIN configuration
#
# Accept everything for/from administrators :
# we don't accept to forward to destination admin to avoid user->admin
# but accept forwarding from source admin
ip6tables -A INPUT -s $ADMIN2 -j ACCEPT
ip6tables -A INPUT -s $ADMIN3 -j ACCEPT
ip6tables -A OUTPUT -d $ADMIN2 -j ACCEPT
ip6tables -A OUTPUT -d $ADMIN3 -j ACCEPT
ip6tables -A FORWARD -s $ADMIN2 -j ACCEPT
ip6tables -A FORWARD -s $ADMIN3 -j ACCEPT

#
# -------- STAFF configuration
#

# STAFF --> STAFF
# Drop forwarding ssh/http/https packet from staff to staff (on tcp)
ip6tables -A FORWARD -s $STAFF2  -d $STAFF2 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF2  -d $STAFF3 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $STAFF2 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $STAFF3 -p tcp -m multiport --dports 22,80,443 -j DROP
# Drop forwarding dns packet from staff to staff (on udp)
ip6tables -A FORWARD -s $STAFF2  -d $STAFF2 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $STAFF2  -d $STAFF3 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $STAFF2 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $STAFF3 -p udp --dport 53 -j DROP

# STAFF --> GUEST
# Drop forwarding ssh/http/https packet from staff to guest (on tcp)
ip6tables -A FORWARD -s $STAFF2  -d $GUEST2 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF2  -d $GUEST3 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $GUEST2 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $GUEST3 -p tcp -m multiport --dports 22,80,443 -j DROP
# Drop forwarding dns packet from staff to guest (on udp)
ip6tables -A FORWARD -s $STAFF2  -d $GUEST2 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $STAFF2  -d $GUEST3 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $GUEST2 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $STAFF3  -d $GUEST3 -p udp --dport 53 -j DROP

# STAFF --> SERVICES
# Accept tcp : forwarding http/https
ip6tables -A FORWARD --src $STAFF2 -p tcp -m multiport --dports 80,443 -j ACCEPT
ip6tables -A FORWARD --src $STAFF3 -p tcp -m multiport --dports 80,443 -j ACCEPT
# Accept udp : forwarding dns
ip6tables -A FORWARD --src $STAFF2 -p udp --dport 53 -j ACCEPT
ip6tables -A FORWARD --src $STAFF3 -p udp --dport 53 -j ACCEPT

#
# -------- GUEST configuration
#

# GUEST --> STAFF
# Drop forwarding ssh/http/https packet from guest to staff (on tcp)
ip6tables -A FORWARD -s $GUEST2  -d $STAFF2 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST2  -d $STAFF3 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $STAFF2 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $STAFF3 -p tcp -m multiport --dports 22,80,443 -j DROP
# Drop forwarding dns packet from guest to staff (on udp)
ip6tables -A FORWARD -s $GUEST2  -d $STAFF2 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $GUEST2  -d $STAFF3 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $STAFF2 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $STAFF3 -p udp --dport 53 -j DROP

# GUEST --> GUEST
# Drop forwarding ssh/http/https packet from guest to guest (on tcp)
ip6tables -A FORWARD -s $GUEST2  -d $GUEST2 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST2  -d $GUEST3 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $GUEST2 -p tcp -m multiport --dports 22,80,443 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $GUEST3 -p tcp -m multiport --dports 22,80,443 -j DROP
# Drop forwarding dns packet from guest to guest (on udp)
ip6tables -A FORWARD -s $GUEST2  -d $GUEST2 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $GUEST2  -d $GUEST3 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $GUEST2 -p udp --dport 53 -j DROP
ip6tables -A FORWARD -s $GUEST3  -d $GUEST3 -p udp --dport 53 -j DROP

# GUEST --> SERVICES
# Accept tcp : forwarding http/https
ip6tables -A FORWARD --src $GUEST2 -p tcp -m multiport --dports 80,443 -j ACCEPT
ip6tables -A FORWARD --src $GUEST3 -p tcp -m multiport --dports 80,443 -j ACCEPT
# Accept udp : forwarding dns
ip6tables -A FORWARD --src $GUEST2 -p udp --dport 53 -j ACCEPT
ip6tables -A FORWARD --src $GUEST3 -p udp --dport 53 -j ACCEPT

#
# -------- IOT configuration
#
# Accept staff to send print job to a remote printer
ip6tables -A FORWARD --src $STAFF2 -p tcp --dport 515 -j ACCEPT
ip6tables -A FORWARD --src $STAFF3 -p tcp --dport 515 -j ACCEPT


# Accept ICMPv6
ip6tables -A INPUT -p icmpv6 -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 -j ACCEPT
ip6tables -A FORWARD -p icmpv6 -j ACCEPT

# Accept http/https input in case we will add a website in this Server
ip6tables -A INPUT -p tcp -m multiport --dports 80,443 -j REJECT

# Accept Forwarding DNS queries/answers from outside too
ip6tables -A FORWARD -p udp --dport 53 -j ACCEPT
# Accept Output DNS to allow testing from router
ip6tables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Accept SNMP  protocol (request and response on udp)
ip6tables -A INPUT -p udp -m multiport --dports 161,162 -j ACCEPT
ip6tables -A OUTPUT -p udp -m multiport --dports 161,162 -j ACCEPT
ip6tables -A FORWARD -p udp -m multiport --dports 161,162 -j ACCEPT

# Accept traceroute tool
ip6tables -A INPUT -p udp --dport 33434:33534 -j ACCEPT
ip6tables -A FORWARD -p udp --dport 33434:33534 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 33434:33534 -j ACCEPT

# Log
ip6tables -A INPUT -j LOG
ip6tables -A OUTPUT -j LOG
ip6tables -A FORWARD -j LOG
