#!/bin/bash
SUBNET="$1"
sudo nmap -sn -Pr "$SUBNET"
