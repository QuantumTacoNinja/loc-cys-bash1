#!/bin/bash
# Setup for item8: locked-dir challenge
# Students must find a way to access a directory they have no execute permission on

BASE_DIR="$(dirname "$0")/item8"
FLAG_CONTENT="SMC{y0u_unl0cked_1t}"

mkdir -p "$BASE_DIR/locked-dir"

# Place the flag inside the locked directory
echo "$FLAG_CONTENT" > "$BASE_DIR/locked-dir/flag"

# Create a README hinting at the challenge
cat > "$BASE_DIR/README" <<'EOF'
There is a directory here. Can you get inside it?

Hint: check the permissions.
EOF

# Remove execute bit so directory cannot be entered
chmod -x "$BASE_DIR/locked-dir"

echo "[+] item8 setup complete."
echo "    locked-dir permissions: $(ls -ld "$BASE_DIR/locked-dir")"
