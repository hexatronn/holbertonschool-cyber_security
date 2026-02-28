#!/bin/bash
salt=$(openssl rand -base64 12)
echo -n "${1}${salt}" | openssl sha512 > 3_hash.txt
