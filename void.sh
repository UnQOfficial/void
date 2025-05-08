#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Stylish VOID Header
print_header() {
    clear
    echo -e "${CYAN}"
    echo "██    ██  ██████  ██ ██████  "
    echo "██    ██ ██    ██ ██ ██   ██ "
    echo "██    ██ ██    ██ ██ ██   ██ "
    echo " ██  ██  ██    ██ ██ ██   ██ "
    echo "  ████    ██████  ██ ██████  "
    echo -e "${NC}"
    echo -e "${YELLOW}     Void Ai Code Editor Manager${NC}"
    echo -e "${CYAN}        Author: Mahesh Technicals${NC}"
    echo
}

# Ensure curl and jq are installed
install_dependencies() {
    echo -e "${CYAN}📦 Checking dependencies...${NC}"

    if ! command -v curl &>/dev/null || ! command -v jq &>/dev/null; then
        echo -e "${YELLOW}Installing missing dependencies (curl, jq)...${NC}"

        if command -v apt &>/dev/null; then
            sudo apt update
            sudo apt install -y curl jq
        elif command -v pkg &>/dev/null; then
            pkg update -y
            pkg install -y curl jq
        else
            echo -e "${RED}❌ No supported package manager found.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✅ Dependencies are already installed.${NC}"
    fi
    echo
}

# Detect architecture
get_arch() {
    case "$(uname -m)" in
        aarch64) echo "arm64" ;;
        armv7l | armv6l) echo "armhf" ;;
        x86_64) echo "amd64" ;;
        *) echo "unsupported" ;;
    esac
}

# Install Void Editor
install_void() {
    ARCH=$(get_arch)
    if [ "$ARCH" = "unsupported" ]; then
        echo -e "${RED}❌ Unsupported architecture: $(uname -m)${NC}"
        exit 1
    fi

    echo -e "${CYAN}🔍 Fetching download URL for $ARCH...${NC}"
    URL=$(curl -s https://api.github.com/repos/voideditor/binaries/releases/latest \
        | jq -r --arg arch "$ARCH" '.assets[] | select(.name | endswith("_\($arch).deb")) | .browser_download_url')

    if [ -z "$URL" ]; then
        echo -e "${RED}❌ No download URL found for $ARCH.${NC}"
        exit 1
    fi

    DEB_FILE="/tmp/void_editor_${ARCH}.deb"
    echo -e "${CYAN}⬇️ Downloading Void Ai Code Editor...${NC}"
    curl -L -o "$DEB_FILE" "$URL"

    echo -e "${CYAN}⚙️ Installing Void Ai Code Editor...${NC}"
    if command -v apt &>/dev/null; then
        sudo apt install -y "$DEB_FILE"
    elif command -v dpkg &>/dev/null; then
        sudo dpkg -i "$DEB_FILE" || sudo apt-get install -f -y
    else
        echo -e "${RED}❌ No supported installer found.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Void Ai Code Editor installed successfully!${NC}"
    prompt_return
}

# Uninstall Void Editor
uninstall_void() {
    echo -e "${CYAN}🧹 Removing Void Ai Code Editor...${NC}"
    if command -v apt &>/dev/null; then
        sudo apt remove --purge -y void
    elif command -v dpkg &>/dev/null; then
        sudo dpkg -r void
    else
        echo -e "${RED}❌ Unable to uninstall — no known package manager found.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Void Ai Code Editor uninstalled.${NC}"
    prompt_return
}

# Ask before returning to menu
prompt_return() {
    echo
    read -rp "$(echo -e "${YELLOW}↩️  Return to menu? [Y/n]: ${NC}")" back
    if [[ "$back" =~ ^[Nn]$ ]]; then
        echo -e "${GREEN}👋 Exiting. Goodbye!${NC}"
        exit 0
    fi
}

# Main menu
main_menu() {
    print_header
    echo -e "${YELLOW}1.${NC} Install Void Ai Code Editor"
    echo -e "${YELLOW}2.${NC} Uninstall Void Ai Code Editor"
    echo -e "${YELLOW}3.${NC} Exit"
    echo
    read -rp "$(echo -e "${CYAN}👉 Choose an option (1-3): ${NC}")" choice
    echo

    case "$choice" in
        1)
            install_dependencies
            install_void
            ;;
        2)
            uninstall_void
            ;;
        3)
            echo -e "${GREEN}👋 Exiting. Have a great day!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid option. Try again.${NC}"
            sleep 1
            main_menu
            ;;
    esac
}

# Run menu loop
while true; do
    main_menu
done
