#!/bin/bash
grep -E "Failed password|Accepted password" auth.log | awk '{print $(NF-5)}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}'
