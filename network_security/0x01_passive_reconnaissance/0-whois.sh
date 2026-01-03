#!/bin/bash
whois "$1" | awk -F': *' '/^(Registrant|Admin|Tech) (Name|Organization|Street|City|State\/Province|Postal Code|Country|Phone|Fax|Email):/{r=$1; v=$2; sub(/ .*/,"",r); f=substr($1,length(r)+2); if(f=="Street")v=v" "; print r" "f", "v} /^(Registrant|Admin|Tech) (Phone Ext|Fax Ext):/{r=$1; sub(/ .*/,"",r); f=substr($1,length(r)+2); print r" "f","]' > "$1.csv"
