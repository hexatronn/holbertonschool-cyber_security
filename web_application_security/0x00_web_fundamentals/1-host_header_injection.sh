#!/bin/bash
curl -s -H "Host: $1" -X POST -d "$3" "$2"
