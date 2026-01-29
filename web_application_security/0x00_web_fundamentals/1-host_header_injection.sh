#!/bin/bash
curl -s -H -X "Host: $1" -d "$3" "$2"
