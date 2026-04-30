#!/bin/bash
tail -n 1000 auth.log | awk '/Failed/ {fails[$9]++} /Accepted/ {if (fails[$9] > 3) print $9}' | sort | uniq
