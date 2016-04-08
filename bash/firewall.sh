#!/bin/bash

iptables -P INPUT ACCEPT
iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#Info "[iptables] Done"
#iptables -L -v

##iptables -I INPUT 5 -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
##iptables -I INPUT 5 -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

#iptables --line -vnL
service iptables save
service iptables restart
