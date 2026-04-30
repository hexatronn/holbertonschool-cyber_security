#!/bin/bash
awk '{print $5}' auth.log | sort | uniq -c | sort -rn
