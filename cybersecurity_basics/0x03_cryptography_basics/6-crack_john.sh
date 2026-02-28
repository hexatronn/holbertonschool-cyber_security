#!/bin/bash
john --format=Raw-SHA256 --wordlist=/home/kali/Downloads/rockyou.txt "$1"
