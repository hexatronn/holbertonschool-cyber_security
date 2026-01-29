#!/bin/bash
curl -sH -X "Host: $1" -d "$3" "$2"
