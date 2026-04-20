#!/bin/bash
# Setup for item10: find the campus network subnet
# Students must inspect their network interface and determine the /16 subnet.
# Expected answer: 10.10.0.0/16  (campus range is 10.10.x.x)

BASE_DIR="$(dirname "$0")/item10"

mkdir -p "$BASE_DIR"

cat > "$BASE_DIR/README" <<'EOF'
You are connected to the campus network.

What is the network subnet of this machine? (Use /16 prefix length)

Answer format:  SMC{x.x.x.x/16}

Hint: try  ip addr  or  ifconfig
EOF

# Answer checker script
cat > "$BASE_DIR/check_answer.sh" <<'CHECKER'
#!/bin/bash
# Validates the student's subnet answer against the actual interface

# Detect IP that starts with 10.10.
IP=$(ip -4 addr show scope global | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+' | grep '^10\.10\.' | head -1)

if [ -z "$IP" ]; then
    echo "[!] No 10.10.x.x address found. Are you on the campus network?"
    exit 1
fi

# Derive /16 network (keep first two octets, zero the rest)
IFS='.' read -r o1 o2 o3 o4 <<< "$IP"
EXPECTED_SUBNET="${o1}.${o2}.0.0/16"

echo "[*] Your IP   : $IP"
echo "[*] /16 subnet: $EXPECTED_SUBNET"

read -rp "Enter your answer: " ANSWER

# Normalise input (strip spaces)
ANSWER="${ANSWER// /}"

if [ "$ANSWER" = "$EXPECTED_SUBNET" ]; then
    echo "[+] Correct! SMC{${EXPECTED_SUBNET}}"
else
    echo "[-] Wrong. Keep trying."
fi
CHECKER

chmod +x "$BASE_DIR/check_answer.sh"

echo "[+] item10 setup complete."
echo "    Students run:  bash item10/check_answer.sh"
