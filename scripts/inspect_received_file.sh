#!/usr/bin/env bash
set -euo pipefail

FILE_PATH="${1:-}"

if [[ -z "$FILE_PATH" ]]; then
  echo "Usage: ./inspect_received_file.sh <received_file>"
  exit 1
fi

echo "== file =="
file "$FILE_PATH"

echo
echo "== first 64 bytes =="
head -c 64 "$FILE_PATH" | xxd
