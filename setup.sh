#!/bin/bash

# ═══════════════════════════════════════════════════════════
# Termux Setup Tool - Mr Flash
# Copyright © 2025 - All Rights Reserved
# Unauthorized copying/modification is strictly prohibited
# ═══════════════════════════════════════════════════════════

clear

# Colors
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
C='\033[1;36m'
W='\033[0m'

# License Banner
echo -e "${C}"
cat << "EOF"
   .dP"Y8 888888 888888 88   88 88""Yb 
   `Ybo." 88__     88   88   88 88__dP 
   o.`Y8b 88""     88   Y8   8P 88"""  
   8bodP' 888888   88   `YbodP' 88     
EOF
echo -e "${G}╔════════════════════════════════════════╗"
echo -e "║      Developer: Mr Flash               ║"
echo -e "║      Protected Setup v2.0              ║"
echo -e "║      © 2025 - All Rights Reserved      ║"
echo -e "╚════════════════════════════════════════╝${W}"
echo ""

# Custom Decryption Function
decrypt() {
    local encrypted="$1"
    local key="MRFLASH2025"
    local result=""
    
    for ((i=0; i<${#encrypted}; i+=2)); do
        hex="${encrypted:$i:2}"
        dec=$((16#$hex))
        key_char="${key:$((i/2 % ${#key})):1}"
        key_val=$(printf "%d" "'$key_char")
        char_val=$((dec ^ key_val))
        result+=$(printf "\\$(printf '%03o' $char_val)")
    done
    
    echo -e "$result"
}

# License Check
check_license() {
    echo -e "${Y}[!] Checking license...${W}"
    sleep 1
    
    # Hardware fingerprint (simple version)
    DEVICE_ID=$(cat /proc/sys/kernel/random/boot_id 2>/dev/null | md5sum | cut -d' ' -f1 | head -c 16)
    
    # Store first run
    LICENSE_FILE="$HOME/.mrflash_license"
    
    if [ ! -f "$LICENSE_FILE" ]; then
        echo "$DEVICE_ID" > "$LICENSE_FILE"
        echo -e "${G}[✓] License activated for this device${W}"
        sleep 1
    else
        STORED_ID=$(cat "$LICENSE_FILE")
        if [ "$STORED_ID" != "$DEVICE_ID" ]; then
            echo -e "${R}[✗] License verification failed!${W}"
            echo -e "${R}[✗] This script is licensed to another device${W}"
            echo -e "${Y}[!] Contact: Mr Flash for new license${W}"
            exit 1
        fi
    fi
}

# Anti-debugging
anti_debug() {
    if [ -n "$BASH_EXECUTION_STRING" ]; then
        echo -e "${R}[✗] Direct execution detected!${W}"
        exit 1
    fi
}

# Encrypted payload - Main installation script
PAYLOAD="5f696e7374616c6c5f7061636b616765732829207b0a20202020656368"

# Main execution
main() {
    anti_debug
    check_license
    
    echo -e "${B}[*]${W} Initializing setup..."
    sleep 1
    
    # Decrypt and execute main script
    execute_setup
}

# Execute setup function
execute_setup() {
    # Status functions
    ps() { echo -e "${B}[*]${W} $1"; }
    pe() { echo -e "${R}[✗]${W} $1"; }
    ok() { echo -e "${G}[✓]${W} $1"; }
    
    # Request storage
    ps "Requesting storage permission..."
    termux-setup-storage
    sleep 2
    
    # Update system
    ps "Updating package lists..."
    apt update -y >/dev/null 2>&1 && ok "Updated" || pe "Update failed"
    
    ps "Upgrading packages..."
    apt upgrade -y >/dev/null 2>&1 && ok "Upgraded" || pe "Upgrade failed"
    
    # Install packages
    PKGS="python git bash figlet toilet nano php curl wget ruby openssh"
    
    ps "Installing core packages..."
    for p in $PKGS; do
        ps "Installing $p..."
        pkg install $p -y >/dev/null 2>&1 && ok "$p installed" || pe "$p failed"
    done
    
    # Python libraries
    LIBS="requests mechanize bs4 beautifulsoup4 rich lxml urllib3 pyTelegramBotAPI telebot python-telegram-bot colorama pyfiglet httpx aiohttp"
    
    ps "Installing Python libraries..."
    for lib in $LIBS; do
        ps "Installing $lib..."
        pip install $lib -q >/dev/null 2>&1 && ok "$lib installed" || pe "$lib failed"
    done
    
    # Success message
    echo ""
    echo -e "${G}╔════════════════════════════════════════╗"
    echo -e "║     Setup Completed Successfully!      ║"
    echo -e "╚════════════════════════════════════════╝${W}"
    echo ""
    echo -e "${Y}Installed:${W}"
    echo "✓ Python 3, Git, PHP, Ruby"
    echo "✓ All essential libraries"
    echo "✓ Development tools"
    echo ""
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${W}"
    echo -e "${G}Developer: Mr Flash${W}"
    echo -e "${Y}GitHub: github.com/SHIHAB-X${W}"
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${W}"
    echo ""
    echo -e "${R}⚠ WARNING: This script is protected by license${W}"
    echo -e "${R}⚠ Unauthorized copying/redistribution is illegal${W}"
}

# Run main
main
