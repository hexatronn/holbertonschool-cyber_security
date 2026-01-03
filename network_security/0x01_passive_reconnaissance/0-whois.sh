#!/bin/bash
whois "$1" | awk -F': *' '/^(Registrant|Admin|Tech) /{sec=$1} /^(Registrant|Admin|Tech) (Name|Organization|Street|City|State\/Province|Postal Code|Country|Phone|Fax|Email)/{f=$2; if($1~/(Street)/)f=f" "; print sec" "substr($1,length(sec)+2)","(f? " "f:"")} /^(Registrant|Admin|Tech) (Phone Ext|Fax Ext)/{print sec" "substr($1,length(sec)+2)","]' > "$1.csv"
