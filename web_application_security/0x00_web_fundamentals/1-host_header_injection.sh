#!/bin/bash
curl -sH "Host: $1" -d "$3" "$2"
