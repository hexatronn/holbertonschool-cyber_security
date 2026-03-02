#!/bin/bash
iptables -A INPUT -p tcp --dport ssh -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT && iptables -A INPUT -j DROP
