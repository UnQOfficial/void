#!/bin/bash



# Enhanced Colors and Styles
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
BLINK='\033[5m'
UNDERLINE='\033[4m'
NC='\033[0m'

# Global Variables
VOID_INSTALL_DIR="/opt/void"
VOID_BIN_PATH="/usr/local/bin/void"
DESKTOP_FILE="/usr/share/applications/void.desktop"
VERSION_FILE="/opt/void/.version"

# Get terminal dimensions
get_terminal_width() {
    tput cols 2>/dev/null || echo 80
}

# Create centered text
center_text() {
    local text="$1"
    local width=$(get_terminal_width)
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%*s%s\n" $padding "" "$text"
}

# Enhanced VOID Header with responsive design
print_header() {
    clear
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${PURPLE}${BOLD}"
    echo "╔${border}╗"
    echo "║$(printf "%*s" $((width)) "")║"
    center_text "██    ██  ██████  ██ ██████  "
    center_text "██    ██ ██    ██ ██ ██   ██ "
    center_text "██    ██ ██    ██ ██ ██   ██ "
    center_text " ██  ██  ██    ██ ██ ██   ██ "
    center_text "  ████    ██████  ██ ██████  "
    echo "║$(printf "%*s" $((width)) "")║"
    echo "╚${border}╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}${BOLD}$(center_text "🚀 VOID AI CODE EDITOR MANAGER 🚀")${NC}"
    echo -e "${YELLOW}${BOLD}$(center_text "Author: Sandeep Gaddam")${NC}"
    echo -e "${DIM}${BLUE}$(center_text "GitHub: github.com/UnQOfficial/void")${NC}"
    echo
    echo -e "${GREEN}${BOLD}${border}${NC}"
    echo
}

# Advanced loading animation with progress
show_loading() {
    local message="$1"
    local duration="${2:-3}"
    local width=$(get_terminal_width)
    
    echo -ne "${CYAN}${message}${NC}"
    
    for i in $(seq 1 $duration); do
        for char in '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'; do
            local progress=$(( (i * 10) / duration ))
            local bar=$(printf "█%.0s" $(seq 1 $progress))
            local empty=$(printf "░%.0s" $(seq 1 $((10 - progress))))
            echo -ne "\r${CYAN}${message} ${YELLOW}${char} ${GREEN}[${bar}${empty}] ${progress}0%${NC}"
            sleep 0.1
        done
    done
    echo -e "\r${CYAN}${message} ${GREEN}✓ Complete!$(printf "%*s" $((width - ${#message} - 12)) "")${NC}"
}

# Check current installed version
get_installed_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "Not installed"
    fi
}

# Get latest version from GitHub
get_latest_version() {
    curl -s https://api.github.com/repos/voideditor/binaries/releases/latest | jq -r '.tag_name' 2>/dev/null || echo "unknown"
}

# Enhanced status display
show_status() {
    local width=$(get_terminal_width)
    local border=$(printf "─%.0s" $(seq 1 $((width - 4))))
    
    echo -e "${BLUE}${BOLD}┌─${border}─┐${NC}"
    echo -e "${BLUE}${BOLD}│${NC} ${WHITE}${BOLD}System Status${NC}$(printf "%*s" $((width - 16)) "")${BLUE}${BOLD}│${NC}"
    echo -e "${BLUE}${BOLD}├─${border}─┤${NC}"
    
    local current_version=$(get_installed_version)
    local latest_version=$(get_latest_version)
    local arch=$(uname -m)
    
    printf "${BLUE}${BOLD}│${NC} ${CYAN}Architecture:${NC} %-20s%*s${BLUE}${BOLD}│${NC}\n" "$arch" $((width - 36)) ""
    printf "${BLUE}${BOLD}│${NC} ${CYAN}Installed:${NC}    %-20s%*s${BLUE}${BOLD}│${NC}\n" "$current_version" $((width - 36)) ""
    printf "${BLUE}${BOLD}│${NC} ${CYAN}Latest:${NC}       %-20s%*s${BLUE}${BOLD}│${NC}\n" "$latest_version" $((width - 36)) ""
    
    if [ "$current_version" != "Not installed" ] && [ "$current_version" != "$latest_version" ]; then
        printf "${BLUE}${BOLD}│${NC} ${YELLOW}${BLINK}Update Available!${NC}%*s${BLUE}${BOLD}│${NC}\n" $((width - 22)) ""
    elif [ "$current_version" = "$latest_version" ]; then
        printf "${BLUE}${BOLD}│${NC} ${GREEN}Up to date!${NC}%*s${BLUE}${BOLD}│${NC}\n" $((width - 16)) ""
    fi
    
    echo -e "${BLUE}${BOLD}└─${border}─┘${NC}"
    echo
}

# Fix repositories with better handling
fix_repositories() {
    echo -e "${YELLOW}🔧 Optimizing system repositories...${NC}"
    
    if [ -f /etc/apt/sources.list ]; then
        show_loading "Creating backup" 2
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%Y%m%d_%H%M%S)
        
        show_loading "Cleaning broken repositories" 2
        sudo sed -i '/buster/d' /etc/apt/sources.list
        
        if [ -d /etc/apt/sources.list.d ]; then
            sudo find /etc/apt/sources.list.d -name "*.list" -exec sed -i '/buster/d' {} \;
        fi
    fi
    
    echo -e "${GREEN}✅ Repository optimization completed!${NC}"
    echo
}

# Enhanced dependency installation
install_dependencies() {
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${CYAN}${BOLD}╔${border}╗${NC}"
    echo -e "${CYAN}${BOLD}║$(center_text "📦 DEPENDENCY MANAGEMENT")║${NC}"
    echo -e "${CYAN}${BOLD}╚${border}╝${NC}"
    echo

    fix_repositories

    if ! command -v curl &>/dev/null || ! command -v jq &>/dev/null || ! command -v tar &>/dev/null; then
        echo -e "${YELLOW}⚙️  Installing required packages...${NC}"

        if command -v apt &>/dev/null; then
            show_loading "Updating package database" 3
            sudo apt update -qq 2>/dev/null || echo -e "${YELLOW}⚠️  Some repos failed, continuing...${NC}"
            
            show_loading "Installing dependencies (curl, jq, tar)" 4
            sudo apt install -y curl jq tar --fix-missing -qq
        elif command -v pkg &>/dev/null; then
            show_loading "Updating Termux packages" 3
            pkg update -y -qq
            show_loading "Installing dependencies" 3
            pkg install -y curl jq tar -qq
        else
            echo -e "${RED}❌ No supported package manager found!${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✅ All dependencies satisfied!${NC}"
    fi
    
    echo -e "${GREEN}${BOLD}${border}${NC}"
    echo
}

# Enhanced architecture detection
get_arch() {
    local arch=$(uname -m)
    
    case "$arch" in
        aarch64) echo "arm64" ;;
        armv7l | armv6l) echo "armhf" ;;
        x86_64) echo "x64" ;;
        loongarch64) echo "loong64" ;;
        ppc64le) echo "ppc64le" ;;
        riscv64) echo "riscv64" ;;
        *) echo "unsupported" ;;
    esac
}

# Display architecture info
show_arch_info() {
    local arch=$(uname -m)
    local mapped_arch=$(get_arch)
    echo -e "${CYAN}🔍 Architecture detected: ${YELLOW}${BOLD}${arch}${NC} → ${GREEN}${mapped_arch}${NC}"
}

# Create desktop entry
create_desktop_entry() {
    echo -e "${CYAN}🖥️  Creating desktop integration...${NC}"
    
    sudo mkdir -p "$(dirname "$DESKTOP_FILE")"
    
    sudo tee "$DESKTOP_FILE" > /dev/null << EOF
[Desktop Entry]
Name=Void Editor
Comment=Advanced Code Editor
Exec=$VOID_BIN_PATH --no-sandbox %F
Icon=void
Terminal=false
Type=Application
Categories=Development;TextEditor;
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/javascript;application/json;text/html;text/xml;text/css;
EOF

    echo -e "${GREEN}✅ Desktop entry created successfully!${NC}"
}

# Install or update Void Editor
install_void() {
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${PURPLE}${BOLD}╔${border}╗${NC}"
    echo -e "${PURPLE}${BOLD}║$(center_text "🚀 INSTALLATION / UPDATE MODE")║${NC}"
    echo -e "${PURPLE}${BOLD}╚${border}╝${NC}"
    echo
    
    show_arch_info
    local ARCH=$(get_arch)
    if [ "$ARCH" = "unsupported" ]; then
        echo -e "${RED}❌ Architecture $(uname -m) is not supported!${NC}"
        echo -e "${YELLOW}💡 Supported: x64, arm64, armhf, loong64, ppc64le, riscv64${NC}"
        return 1
    fi

    show_loading "Fetching latest release information" 4
    local LATEST_VERSION=$(get_latest_version)
    
    if [ "$LATEST_VERSION" = "unknown" ]; then
        echo -e "${RED}❌ Failed to fetch version information!${NC}"
        return 1
    fi

    local CURRENT_VERSION=$(get_installed_version)
    
    if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
        echo -e "${GREEN}✅ Void Editor is already up to date! (${LATEST_VERSION})${NC}"
        return 0
    fi

    # Construct download URL
    local FILENAME="Void-linux-${ARCH}-${LATEST_VERSION}.tar.gz"
    local URL="https://github.com/voideditor/binaries/releases/download/${LATEST_VERSION}/${FILENAME}"
    
    echo -e "${CYAN}📦 Package: ${YELLOW}${FILENAME}${NC}"
    echo -e "${CYAN}🔗 URL: ${DIM}${URL}${NC}"
    echo

    local DOWNLOAD_PATH="/tmp/${FILENAME}"
    
    echo -e "${CYAN}⬇️  Downloading Void Editor ${LATEST_VERSION}...${NC}"
    if curl -L --progress-bar -o "$DOWNLOAD_PATH" "$URL"; then
        echo -e "${GREEN}✅ Download completed!${NC}"
    else
        echo -e "${RED}❌ Download failed! Check internet connection.${NC}"
        return 1
    fi

    echo -e "${CYAN}📁 Installing to system...${NC}"
    
    # Create installation directory
    sudo mkdir -p "$VOID_INSTALL_DIR"
    sudo mkdir -p "$(dirname "$VOID_BIN_PATH")"
    
    show_loading "Extracting archive" 3
    sudo tar -xzf "$DOWNLOAD_PATH" -C "$VOID_INSTALL_DIR" --strip-components=1
    
    show_loading "Creating system links" 2
    sudo ln -sf "$VOID_INSTALL_DIR/void" "$VOID_BIN_PATH"
    sudo chmod +x "$VOID_BIN_PATH"
    
    # Save version info
    echo "$LATEST_VERSION" | sudo tee "$VERSION_FILE" > /dev/null
    
    # Create desktop entry
    create_desktop_entry
    
    # Cleanup
    rm -f "$DOWNLOAD_PATH"
    
    echo -e "${GREEN}${BOLD}╔${border}╗${NC}"
    echo -e "${GREEN}${BOLD}║$(center_text "🎉 SUCCESS!")║${NC}"
    echo -e "${GREEN}${BOLD}║$(center_text "Void Editor ${LATEST_VERSION} installed!")║${NC}"
    echo -e "${GREEN}${BOLD}║$(center_text "Launch: 'void' or from applications menu")║${NC}"
    echo -e "${GREEN}${BOLD}╚${border}╝${NC}"
    
    prompt_return
}

# Uninstall Void Editor
uninstall_void() {
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${RED}${BOLD}╔${border}╗${NC}"
    echo -e "${RED}${BOLD}║$(center_text "🗑️  UNINSTALLATION MODE")║${NC}"
    echo -e "${RED}${BOLD}╚${border}╝${NC}"
    echo
    
    if [ ! -f "$VERSION_FILE" ]; then
        echo -e "${YELLOW}⚠️  Void Editor is not installed via this manager.${NC}"
        prompt_return
        return
    fi
    
    local current_version=$(get_installed_version)
    echo -e "${YELLOW}⚠️  About to remove Void Editor ${current_version}${NC}"
    echo -e "${RED}${BOLD}⚠️  This action cannot be undone!${NC}"
    echo
    
    read -rp "$(echo -e "${RED}Type '${BOLD}CONFIRM${NC}${RED}' to proceed: ${NC}")" confirm
    
    if [ "$confirm" != "CONFIRM" ]; then
        echo -e "${CYAN}Operation cancelled.${NC}"
        prompt_return
        return
    fi
    
    show_loading "Removing installation directory" 3
    sudo rm -rf "$VOID_INSTALL_DIR"
    
    show_loading "Removing system links" 2
    sudo rm -f "$VOID_BIN_PATH"
    
    show_loading "Removing desktop integration" 2
    sudo rm -f "$DESKTOP_FILE"
    
    echo -e "${GREEN}✅ Void Editor completely removed!${NC}"
    prompt_return
}

# Enhanced return prompt
prompt_return() {
    local width=$(get_terminal_width)
    local border=$(printf "─%.0s" $(seq 1 $((width - 4))))
    
    echo
    echo -e "${CYAN}${BOLD}┌─${border}─┐${NC}"
    echo -e "${CYAN}${BOLD}│$(center_text "Press any key to return to main menu...")│${NC}"
    echo -e "${CYAN}${BOLD}└─${border}─┘${NC}"
    
    read -n 1 -s
}

# Enhanced main menu
main_menu() {
    print_header
    show_status
    
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${WHITE}${BOLD}╔${border}╗${NC}"
    echo -e "${WHITE}${BOLD}║$(center_text "🎯 AVAILABLE OPTIONS")║${NC}"
    echo -e "${WHITE}${BOLD}╚${border}╝${NC}"
    echo
    
    echo -e "${GREEN}${BOLD} 1.${NC} ${CYAN}🚀 Install/Update Void Editor${NC}"
    echo -e "${RED}${BOLD} 2.${NC} ${YELLOW}🗑️  Uninstall Void Editor${NC}"
    echo -e "${BLUE}${BOLD} 3.${NC} ${PURPLE}📊 Show Detailed Status${NC}"
    echo -e "${WHITE}${BOLD} 4.${NC} ${DIM}🚪 Exit Application${NC}"
    echo
    
    echo -e "${CYAN}${BOLD}${border}${NC}"
    echo
    
    read -rp "$(echo -e "${PURPLE}${BOLD}👉 Select option (1-4): ${NC}")" choice
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
            show_detailed_status
            ;;
        4)
            echo -e "${GREEN}${BOLD}╔${border}╗${NC}"
            echo -e "${GREEN}${BOLD}║$(center_text "👋 Thank you for using Void Manager!")║${NC}"
            echo -e "${GREEN}${BOLD}║$(center_text "Happy coding! 🚀")║${NC}"
            echo -e "${GREEN}${BOLD}╚${border}╝${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid selection! Please choose 1-4.${NC}"
            sleep 2
            ;;
    esac
}

# Detailed status display
show_detailed_status() {
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${BLUE}${BOLD}╔${border}╗${NC}"
    echo -e "${BLUE}${BOLD}║$(center_text "📊 DETAILED SYSTEM STATUS")║${NC}"
    echo -e "${BLUE}${BOLD}╚${border}╝${NC}"
    echo
    
    echo -e "${CYAN}${BOLD}System Information:${NC}"
    echo -e "  OS: $(uname -o)"
    echo -e "  Kernel: $(uname -r)"
    echo -e "  Architecture: $(uname -m)"
    echo
    
    echo -e "${CYAN}${BOLD}Void Editor Status:${NC}"
    if [ -f "$VERSION_FILE" ]; then
        echo -e "  Installation: ${GREEN}✓ Installed${NC}"
        echo -e "  Version: $(cat "$VERSION_FILE")"
        echo -e "  Location: $VOID_INSTALL_DIR"
        echo -e "  Binary: $VOID_BIN_PATH"
        echo -e "  Desktop Entry: $([ -f "$DESKTOP_FILE" ] && echo "${GREEN}✓${NC}" || echo "${RED}✗${NC}")"
    else
        echo -e "  Installation: ${RED}✗ Not installed${NC}"
    fi
    
    echo
    prompt_return
}

# Startup message
echo -e "${CYAN}${BOLD}Initializing Advanced Void Manager...${NC}"
show_loading "System check" 2
echo

# Main execution loop
while true; do
    main_menu
done
