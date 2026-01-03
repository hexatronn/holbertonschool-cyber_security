#!/bin/bash

[ -z "$1" ] && exit 1

DOMAIN="$1"
OUTPUT="${DOMAIN}.csv"

whois "$DOMAIN" | awk -F': ' '
BEGIN {
    section = ""
}

/^Registrant / { section="Registrant" }
/^Admin /      { section="Admin" }
/^Tech /       { section="Tech" }


/ Name:/ {
    print section " Name," $2
}

/ Organization:/ {
    print section " Organization," $2
}

/ Street:/ {
    print section " Street," $2 " "
}

/ City:/ {
    print section " City," $2
}

/ State\/Province:/ {
    print section " State/Province," $2
}

/ Postal Code:/ {
    print section " Postal Code," $2
}

/ Country:/ {
    print section " Country," $2
}

/ Phone:/ && !/Ext/ {
    print section " Phone," $2
}

/ Phone Ext:/ {
    print section " Phone Ext:,"
}

/ Fax:/ && !/Ext/ {
    print section " Fax," $2
}

/ Fax Ext:/ {
    print section " Fax Ext:,"
}

/ Email:/ {
    print section " Email," $2
}
' > "$OUTPUT"
