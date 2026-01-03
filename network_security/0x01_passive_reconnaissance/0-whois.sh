#!/bin/bash
whois "$1" | awk -F': ' '/^(Registrant|Admin|Tech)/{s=$1} /(Name|Organization|Street|City|State\/Province|Postal Code|Country|Phone Ext|Fax Ext|Email|Phone|Fax):/{if($2=="")$2=""; if($1~/(Street)/)$2=$2" "; print s" "$1","$2}' > "$1.csv"
