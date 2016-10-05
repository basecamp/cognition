#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "steps:"

echo "  - name: \":ruby: dynamic step\""
echo "    command: \"/bin/true\""
echo "    agents:"
echo "      queue: elastic"
echo

echo "  - name: \":ruby: dynamic step 2\""
echo "    command: \"/bin/true\""
echo "    agents:"
echo "      queue: elastic"
echo