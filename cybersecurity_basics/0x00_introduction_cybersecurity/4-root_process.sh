#!/bin/bash
ps aux -U $1 --no-headers | grep -v "      0     0"
