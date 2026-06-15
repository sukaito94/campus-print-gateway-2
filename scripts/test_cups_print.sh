#!/usr/bin/env bash
set -euo pipefail

PRINTER_NAME="${1:-}"
TEST_FILE="${2:-}"

if [[ -z "$PRINTER_NAME" || -z "$TEST_FILE" ]]; then
  echo "Usage: ./test_cups_print.sh <printer_name> <test_file>"
  exit 1
fi

lpstat -p "$PRINTER_NAME"
lp -d "$PRINTER_NAME" "$TEST_FILE"
