#!/bin/sh

echo "Stopping iptables-persistent service"
service iptables-persistent flush

echo "Flushing current rules"
iptables -F

echo "Allowing loopback devices to connect"
iptables -A INPUT -i lo -j ACCEPT

echo "Allowing related and established connections"
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

echo "Allowing ssh to connect freely"
iptables -A INPUT -p tcp --dport ssh -j ACCEPT

echo "Allowing webtraffic as some programs may use a webserver"
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

echo "Disabling all remaining traffic"
iptables -A INPUT -j DROP

echo "---------------------------------------------------------"
echo "WARNING THIS SCRIPT DOES NOT MAKE THE SETTINGS PERSISTENT"
echo "TEST EVERYTHING WORKS THEN MAKE PERSISTENT"
echo "---------------------------------------------------------"
