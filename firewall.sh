#!/bin/sh

echo "Flushing current rules"
iptables -F

echo "Allowing related and established connections"
iptables -A INPUT -m conntrack --cstate ESTABLISHED,RELATED -j ACCEPT

echo "Allowing ssh to connect freely"
iptables -A INPUT -p tcp --dport ssh -j ACCEPT

echo "Allowing webtraffic as some programs may use a webserver"
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

ehco "Disabling all remaining traffic"
iptables -A INPUT -j DROP
