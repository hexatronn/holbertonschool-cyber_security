#!/bin/bash

ENCODED=$(echo "$1" | sed 's/^{xor}//')

echo "$ENCODED" | base64 -d | python3 -c "import sys; print(''.join(chr(b ^ 95) for b in sys.stdin.buffer.read()))"
