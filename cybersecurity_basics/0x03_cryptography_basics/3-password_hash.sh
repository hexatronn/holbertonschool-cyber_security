#!/bin/bash
echo -n "$1$(openssl rand -base64 12)" | openssl sha512 > 3_hash.txt
