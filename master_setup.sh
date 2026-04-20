#!/bin/bash
# Run this script after cloning to set up the lab environment.
# Usage: bash master_setup.sh

set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[*] Cleaning previous setup..."
rm -rf "$BASE_DIR/item8" "$BASE_DIR/item9" "$BASE_DIR/item10"

echo
echo "[*] Setting up item8 (locked directory)..."
bash "$BASE_DIR/setup_item8.sh"

echo
echo "[*] Setting up item9 (encoded files)..."
if [ "$(id -u)" -eq 0 ]; then
    bash "$BASE_DIR/setup_item9.sh"
else
    sudo bash "$BASE_DIR/setup_item9.sh"
fi

echo
echo "[*] Setting up item10 (network challenge)..."
bash "$BASE_DIR/setup_item10.sh"

echo
echo "[*] Cleaning up setup scripts..."
rm -f "$BASE_DIR/setup_item8.sh" "$BASE_DIR/setup_item9.sh" "$BASE_DIR/setup_item10.sh"

echo
echo "[*] All done. Happy hacking!"
