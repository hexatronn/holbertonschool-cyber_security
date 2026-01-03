#!/bin/bash
subfinder -d $1 -silent | tee /tmp/subs.$$ | while read h; do ip=$(dig +short $h | head -n1); [ -n "$ip" ] && echo "$h,$ip"; done > $1.txt
