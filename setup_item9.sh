#!/bin/bash
# Setup for item9: base64 encoded flag split across multiple files
# Students must: cat * | base64 -d  (or base64 --decode on some systems)
# Files are owned by another user (root or a dedicated user) — world-readable only.

BASE_DIR="$(dirname "$0")/item9"
FLAG_CONTENT="SMC{b4se64_1s_n0t_encrypti0n}"

mkdir -p "$BASE_DIR/secret-files"

# Encode the flag as base64, then split into 3 parts across files
ENCODED=$(echo -n "$FLAG_CONTENT" | base64)

# Split encoded string into roughly equal thirds
LEN=${#ENCODED}
A=$(( LEN / 3 ))
B=$(( LEN / 3 * 2 ))

PART1="${ENCODED:0:$A}"
PART2="${ENCODED:$A:$A}"
PART3="${ENCODED:$B}"

# Write parts to files (no newline so cat * joins them cleanly)
printf "%s" "$PART1" > "$BASE_DIR/secret-files/file1"
printf "%s" "$PART2" > "$BASE_DIR/secret-files/file2"
printf "%s" "$PART3" > "$BASE_DIR/secret-files/file3"
# Add trailing newline only on last file so base64 -d is happy
printf "\n"  >> "$BASE_DIR/secret-files/file3"

cat > "$BASE_DIR/README" <<'EOF'
Someone left some files here. They look like gibberish...
Maybe reading them all together and decoding will reveal something?

Tip: there are multiple files. Think about how to read them all at once.
EOF

# Make files world-readable but owned by root (requires sudo)
if [ "$(id -u)" -eq 0 ]; then
    chown root:root "$BASE_DIR/secret-files/file1" \
                    "$BASE_DIR/secret-files/file2" \
                    "$BASE_DIR/secret-files/file3"
    chmod 644 "$BASE_DIR/secret-files/file1" \
              "$BASE_DIR/secret-files/file2" \
              "$BASE_DIR/secret-files/file3"
    echo "[+] Files owned by root."
else
    echo "[!] Not running as root — skipping chown. Run with sudo for full setup."
fi

echo "[+] item9 setup complete."
echo "    Expected student command:  cat secret-files/* | base64 -d"
echo "    Expected output:           $FLAG_CONTENT"
