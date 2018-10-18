#!/bin/bash

# Accept incomming and outgoing packet for DNS
ip6tables -A INPUT -p tcp --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 53 -j ACCEPT
