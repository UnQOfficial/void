#!/bin/bash

# Color Scheme - Modern & Professional
PRIMARY='\033[0;36m'    # Cyan
SECONDARY='\033[0;35m'  # Purple
SUCCESS='\033[0;32m'    # Green
WARNING='\033[1;33m'    # Yellow
ERROR='\033[0;31m'      # Red
INFO='\033[0;34m'       # Blue
ACCENT='\033[1;37m'     # White Bold
DIM='\033[2m'           # Dim
BOLD='\033[1m'          # Bold
BLINK='\033[5m'         # Blink
NC='\033[0m'            # No Color

# System Configuration
VOID_INSTALL_DIR="/opt/void"
VOID_BIN_PATH="/usr/local/bin/void"
DESKTOP_FILE="/usr/share/applications/void.desktop"
VERSION_FILE="/opt/void/.version"
GITHUB_API="https://api.github.com/repos/voideditor/binaries/releases/latest"

get_terminal_width() {
    tput cols 2>/dev/null || echo 80
}

center_text() {
    local text="$1"
    local width=$(get_terminal_width)
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%*s%s\n" $padding "" "$text"
}

print_professional_header() {
    clear
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${PRIMARY}${BOLD}"
    echo "╔${border}╗"
    echo "║$(printf "%*s" $((width)) "")║"
    echo "║$(printf "%*s" $((width)) "")║"
    
    # Clean void ASCII Banner
    center_text "██    ██  ██████  ██ ██████  "
    center_text "██    ██ ██    ██ ██ ██   ██ "
    center_text "██    ██ ██    ██ ██ ██   ██ "
    center_text " ██  ██  ██    ██ ██ ██   ██ "
    center_text "  ████    ██████  ██ ██████  "
    
    echo "║$(printf "%*s" $((width)) "")║"
    echo "║$(printf "%*s" $((width)) "")║"
    echo "╚${border}╝"
    echo -e "${NC}"
    
    echo -e "${SECONDARY}${BOLD}$(center_text "🚀 PROFESSIONAL CODE EDITOR MANAGER 🚀")${NC}"
    echo -e "${ACCENT}$(center_text "Advanced Installation & Management System")${NC}"
    echo -e "${DIM}$(center_text "github.com/UnQOfficial/void")${NC}"
    echo
    echo -e "${PRIMARY}${BOLD}${border}${NC}"
    echo
}

show_modern_progress() {
    local message="$1"
    local current="$2"
    local total="$3"
    local width=$(get_terminal_width)
    local bar_width=50
    local progress=$(( (current * 100) / total ))
    local filled=$(( (current * bar_width) / total ))
    local empty=$(( bar_width - filled ))
    
    local bar_filled=$(printf "█%.0s" $(seq 1 $filled))
    local bar_empty=$(printf "░%.0s" $(seq 1 $empty))
    
    printf "\r${PRIMARY}${message}${NC} ${SUCCESS}[${bar_filled}${DIM}${bar_empty}${NC}${SUCCESS}]${NC} ${ACCENT}${progress}%%${NC}"
    
    if [ "$current" -eq "$total" ]; then
        echo -e " ${SUCCESS}✓${NC}"
    fi
}

animate_loading() {
    local message="$1"
    local steps="${2:-10}"
    
    echo -e "${PRIMARY}${message}${NC}"
    for i in $(seq 1 $steps); do
        show_modern_progress "  Processing" $i $steps
        sleep 0.2
    done
    echo
}

get_system_info() {
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

get_installed_version() {
    [ -f "$VERSION_FILE" ] && cat "$VERSION_FILE" || echo "Not installed"
}

get_latest_version() {
    curl -s "$GITHUB_API" | jq -r '.tag_name' 2>/dev/null || echo "unknown"
}

display_system_status() {
    local width=$(get_terminal_width)
    local border=$(printf "─%.0s" $(seq 1 $((width - 4))))
    
    echo -e "${INFO}${BOLD}┌─${border}─┐${NC}"
    echo -e "${INFO}${BOLD}│${NC} ${ACCENT}SYSTEM STATUS${NC}$(printf "%*s" $((width - 16)) "")${INFO}${BOLD}│${NC}"
    echo -e "${INFO}${BOLD}├─${border}─┤${NC}"
    
    local current_version=$(get_installed_version)
    local latest_version=$(get_latest_version)
    local arch=$(uname -m)
    local mapped_arch=$(get_system_info)
    
    printf "${INFO}${BOLD}│${NC} ${PRIMARY}Architecture:${NC} %-20s%*s${INFO}${BOLD}│${NC}\n" "$arch → $mapped_arch" $((width - 36)) ""
    printf "${INFO}${BOLD}│${NC} ${PRIMARY}Current:${NC}      %-20s%*s${INFO}${BOLD}│${NC}\n" "$current_version" $((width - 36)) ""
    printf "${INFO}${BOLD}│${NC} ${PRIMARY}Latest:${NC}       %-20s%*s${INFO}${BOLD}│${NC}\n" "$latest_version" $((width - 36)) ""
    
    if [ "$current_version" != "Not installed" ] && [ "$current_version" != "$latest_version" ]; then
        printf "${INFO}${BOLD}│${NC} ${WARNING}${BLINK}🔄 Update Available${NC}%*s${INFO}${BOLD}│${NC}\n" $((width - 22)) ""
    elif [ "$current_version" = "$latest_version" ]; then
        printf "${INFO}${BOLD}│${NC} ${SUCCESS}✅ Up to date${NC}%*s${INFO}${BOLD}│${NC}\n" $((width - 16)) ""
    fi
    
    echo -e "${INFO}${BOLD}└─${border}─┘${NC}"
    echo
}

setup_repositories() {
    echo -e "${PRIMARY}🔧 Optimizing system repositories...${NC}"
    
    if [ -f /etc/apt/sources.list ]; then
        animate_loading "  Creating backup" 5
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null
        
        animate_loading "  Cleaning repositories" 5
        sudo sed -i '/buster/d' /etc/apt/sources.list 2>/dev/null
        
        if [ -d /etc/apt/sources.list.d ]; then
            sudo find /etc/apt/sources.list.d -name "*.list" -exec sed -i '/buster/d' {} \; 2>/dev/null
        fi
    fi
    
    echo -e "${SUCCESS}✅ Repository optimization completed${NC}"
    echo
}

install_dependencies() {
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${SECONDARY}${BOLD}╔${border}╗${NC}"
    echo -e "${SECONDARY}${BOLD}║$(center_text "📦 DEPENDENCY MANAGEMENT")║${NC}"
    echo -e "${SECONDARY}${BOLD}╚${border}╝${NC}"
    echo

    setup_repositories

    if ! command -v curl &>/dev/null || ! command -v jq &>/dev/null || ! command -v tar &>/dev/null; then
        echo -e "${PRIMARY}⚙️  Installing required packages...${NC}"

        if command -v apt &>/dev/null; then
            animate_loading "  Updating package database" 8
            sudo apt update -qq 2>/dev/null || echo -e "${WARNING}⚠️  Some repositories failed${NC}"
            
            animate_loading "  Installing dependencies" 10
            sudo apt install -y curl jq tar --fix-missing -qq 2>/dev/null
        elif command -v pkg &>/dev/null; then
            animate_loading "  Updating Termux packages" 8
            pkg update -y -qq 2>/dev/null
            animate_loading "  Installing dependencies" 8
            pkg install -y curl jq tar -qq 2>/dev/null
        else
            echo -e "${ERROR}❌ No supported package manager found${NC}"
            exit 1
        fi
    else
        echo -e "${SUCCESS}✅ All dependencies satisfied${NC}"
    fi
    
    echo -e "${PRIMARY}${BOLD}${border}${NC}"
    echo
}

create_desktop_integration() {
    echo -e "${PRIMARY}🖥️  Creating desktop integration...${NC}"
    
    sudo mkdir -p "$(dirname "$DESKTOP_FILE")" 2>/dev/null
    
    sudo tee "$DESKTOP_FILE" > /dev/null << EOF
[Desktop Entry]
Name=Void Editor
Comment=Professional Code Editor
Exec=$VOID_BIN_PATH --no-sandbox %F
Icon=void
Terminal=false
Type=Application
Categories=Development;TextEditor;IDE;
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-python;application/javascript;application/json;text/html;text/xml;text/css;text/markdown;
Keywords=editor;development;programming;code;
EOF

    echo -e "${SUCCESS}✅ Desktop integration completed${NC}"
}

show_installation_success() {
    local version="$1"
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    local inner_border=$(printf "─%.0s" $(seq 1 $((width - 4))))
    
    echo
    echo -e "${SUCCESS}${BOLD}╔${border}╗${NC}"
    echo -e "${SUCCESS}${BOLD}║$(printf "%*s" $((width)) "")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "🎉 INSTALLATION COMPLETED SUCCESSFULLY! 🎉")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(printf "%*s" $((width)) "")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "┌${inner_border}┐")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "│ Void Editor ${version} is now ready to use! │")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "└${inner_border}┘")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(printf "%*s" $((width)) "")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "🚀 Launch Commands:")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "• Terminal: ${ACCENT}void${SUCCESS}")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "• Applications Menu: Void Editor")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(printf "%*s" $((width)) "")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "✨ Features Available:")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "• Advanced Code Editor")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "• Desktop Integration")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "• File Association Support")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(printf "%*s" $((width)) "")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "Happy Coding! 💻")║${NC}"
    echo -e "${SUCCESS}${BOLD}║$(printf "%*s" $((width)) "")║${NC}"
    echo -e "${SUCCESS}${BOLD}╚${border}╝${NC}"
}

install_void_editor() {
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${SUCCESS}${BOLD}╔${border}╗${NC}"
    echo -e "${SUCCESS}${BOLD}║$(center_text "🚀 INSTALLATION & UPDATE SYSTEM")║${NC}"
    echo -e "${SUCCESS}${BOLD}╚${border}╝${NC}"
    echo
    
    local ARCH=$(get_system_info)
    echo -e "${PRIMARY}🔍 Architecture: ${ACCENT}$(uname -m)${NC} → ${SUCCESS}${ARCH}${NC}"
    
    if [ "$ARCH" = "unsupported" ]; then
        echo -e "${ERROR}❌ Architecture not supported${NC}"
        echo -e "${WARNING}💡 Supported: x64, arm64, armhf, loong64, ppc64le, riscv64${NC}"
        return 1
    fi

    echo -e "${PRIMARY}📡 Fetching release information...${NC}"
    animate_loading "  Connecting to GitHub API" 6
    
    local LATEST_VERSION=$(get_latest_version)
    if [ "$LATEST_VERSION" = "unknown" ]; then
        echo -e "${ERROR}❌ Failed to fetch version information${NC}"
        return 1
    fi

    local CURRENT_VERSION=$(get_installed_version)
    
    if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
        echo -e "${SUCCESS}✅ Already up to date (${LATEST_VERSION})${NC}"
        return 0
    fi

    local FILENAME="Void-linux-${ARCH}-${LATEST_VERSION}.tar.gz"
    local URL="https://github.com/voideditor/binaries/releases/download/${LATEST_VERSION}/${FILENAME}"
    
    echo
    echo -e "${PRIMARY}📦 Package: ${ACCENT}${FILENAME}${NC}"
    echo -e "${PRIMARY}🌐 Source: ${DIM}GitHub Releases${NC}"
    echo

    local DOWNLOAD_PATH="/tmp/${FILENAME}"
    
    echo -e "${PRIMARY}⬇️  Downloading Void Editor ${LATEST_VERSION}...${NC}"
    if curl -L --progress-bar -o "$DOWNLOAD_PATH" "$URL" 2>/dev/null; then
        echo -e "${SUCCESS}✅ Download completed successfully${NC}"
    else
        echo -e "${ERROR}❌ Download failed - Check internet connection${NC}"
        return 1
    fi

    echo -e "${PRIMARY}📁 Installing to system...${NC}"
    
    sudo mkdir -p "$VOID_INSTALL_DIR" 2>/dev/null
    sudo mkdir -p "$(dirname "$VOID_BIN_PATH")" 2>/dev/null
    
    animate_loading "  Extracting archive" 8
    sudo tar -xzf "$DOWNLOAD_PATH" -C "$VOID_INSTALL_DIR" --strip-components=1 2>/dev/null
    
    animate_loading "  Creating system links" 5
    sudo ln -sf "$VOID_INSTALL_DIR/void" "$VOID_BIN_PATH" 2>/dev/null
    sudo chmod +x "$VOID_BIN_PATH" 2>/dev/null
    
    echo "$LATEST_VERSION" | sudo tee "$VERSION_FILE" > /dev/null 2>&1
    
    create_desktop_integration
    
    rm -f "$DOWNLOAD_PATH" 2>/dev/null
    
    show_installation_success "$LATEST_VERSION"
    
    prompt_continue
}

uninstall_void_editor() {
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${ERROR}${BOLD}╔${border}╗${NC}"
    echo -e "${ERROR}${BOLD}║$(center_text "🗑️  UNINSTALLATION SYSTEM")║${NC}"
    echo -e "${ERROR}${BOLD}╚${border}╝${NC}"
    echo
    
    if [ ! -f "$VERSION_FILE" ]; then
        echo -e "${WARNING}⚠️  Void Editor not installed via this manager${NC}"
        prompt_continue
        return
    fi
    
    local current_version=$(get_installed_version)
    echo -e "${WARNING}⚠️  Removing Void Editor ${current_version}${NC}"
    echo -e "${ERROR}${BOLD}⚠️  This action is irreversible!${NC}"
    echo
    
    read -rp "$(echo -e "${ERROR}Type '${BOLD}YES${NC}${ERROR}' to confirm removal: ${NC}")" confirm
    
    if [ "$confirm" != "YES" ]; then
        echo -e "${PRIMARY}Operation cancelled${NC}"
        prompt_continue
        return
    fi
    
    echo -e "${PRIMARY}🗑️  Removing Void Editor...${NC}"
    animate_loading "  Removing installation" 6
    sudo rm -rf "$VOID_INSTALL_DIR" 2>/dev/null
    
    animate_loading "  Cleaning system links" 4
    sudo rm -f "$VOID_BIN_PATH" 2>/dev/null
    
    animate_loading "  Removing desktop integration" 3
    sudo rm -f "$DESKTOP_FILE" 2>/dev/null
    
    echo -e "${SUCCESS}✅ Complete removal successful${NC}"
    prompt_continue
}

show_detailed_information() {
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${INFO}${BOLD}╔${border}╗${NC}"
    echo -e "${INFO}${BOLD}║$(center_text "📊 DETAILED SYSTEM INFORMATION")║${NC}"
    echo -e "${INFO}${BOLD}╚${border}╝${NC}"
    echo
    
    echo -e "${PRIMARY}${BOLD}System Environment:${NC}"
    echo -e "  OS Distribution: $(lsb_release -d 2>/dev/null | cut -f2 || uname -o)"
    echo -e "  Kernel Version: $(uname -r)"
    echo -e "  Architecture: $(uname -m)"
    echo -e "  Shell: $SHELL"
    echo
    
    echo -e "${PRIMARY}${BOLD}Void Editor Configuration:${NC}"
    if [ -f "$VERSION_FILE" ]; then
        echo -e "  Installation Status: ${SUCCESS}✓ Installed${NC}"
        echo -e "  Version: $(cat "$VERSION_FILE")"
        echo -e "  Install Location: $VOID_INSTALL_DIR"
        echo -e "  Binary Path: $VOID_BIN_PATH"
        echo -e "  Desktop Entry: $([ -f "$DESKTOP_FILE" ] && echo "${SUCCESS}✓ Available${NC}" || echo "${ERROR}✗ Missing${NC}")"
        echo -e "  Launch Command: ${ACCENT}void${NC}"
    else
        echo -e "  Installation Status: ${ERROR}✗ Not installed${NC}"
    fi
    
    echo
    echo -e "${PRIMARY}${BOLD}Dependencies Status:${NC}"
    echo -e "  curl: $(command -v curl >/dev/null && echo "${SUCCESS}✓${NC}" || echo "${ERROR}✗${NC}")"
    echo -e "  jq: $(command -v jq >/dev/null && echo "${SUCCESS}✓${NC}" || echo "${ERROR}✗${NC}")"
    echo -e "  tar: $(command -v tar >/dev/null && echo "${SUCCESS}✓${NC}" || echo "${ERROR}✗${NC}")"
    
    echo
    prompt_continue
}

prompt_continue() {
    local width=$(get_terminal_width)
    local border=$(printf "─%.0s" $(seq 1 $((width - 4))))
    
    echo
    echo -e "${PRIMARY}${BOLD}┌─${border}─┐${NC}"
    echo -e "${PRIMARY}${BOLD}│$(center_text "Press any key to continue...")│${NC}"
    echo -e "${PRIMARY}${BOLD}└─${border}─┘${NC}"
    
    read -n 1 -s
}

display_main_menu() {
    print_professional_header
    display_system_status
    
    local width=$(get_terminal_width)
    local border=$(printf "═%.0s" $(seq 1 $width))
    
    echo -e "${ACCENT}${BOLD}╔${border}╗${NC}"
    echo -e "${ACCENT}${BOLD}║$(center_text "🎯 PROFESSIONAL MANAGEMENT OPTIONS")║${NC}"
    echo -e "${ACCENT}${BOLD}╚${border}╝${NC}"
    echo
    
    echo -e "${SUCCESS}${BOLD} [1]${NC} ${PRIMARY}🚀 Install / Update Void Editor${NC}"
    echo -e "${ERROR}${BOLD} [2]${NC} ${WARNING}🗑️  Uninstall Void Editor${NC}"
    echo -e "${INFO}${BOLD} [3]${NC} ${SECONDARY}📊 Detailed System Information${NC}"
    echo -e "${DIM}${BOLD} [4]${NC} ${DIM}🚪 Exit Application${NC}"
    echo
    
    echo -e "${PRIMARY}${BOLD}${border}${NC}"
    echo
    
    read -rp "$(echo -e "${ACCENT}${BOLD}👉 Select option [1-4]: ${NC}")" choice
    echo

    case "$choice" in
        1)
            install_dependencies
            install_void_editor
            ;;
        2)
            uninstall_void_editor
            ;;
        3)
            show_detailed_information
            ;;
        4)
            local exit_border=$(printf "═%.0s" $(seq 1 $width))
            echo -e "${SUCCESS}${BOLD}╔${exit_border}╗${NC}"
            echo -e "${SUCCESS}${BOLD}║$(center_text "👋 Thank you for using Void Manager!")║${NC}"
            echo -e "${SUCCESS}${BOLD}║$(center_text "Keep coding, keep creating! 🚀")║${NC}"
            echo -e "${SUCCESS}${BOLD}╚${exit_border}╝${NC}"
            exit 0
            ;;
        *)
            echo -e "${ERROR}❌ Invalid selection. Please choose 1-4${NC}"
            sleep 2
            ;;
    esac
}

# Initialize Application
echo -e "${PRIMARY}${BOLD}Initializing Void Manager...${NC}"
animate_loading "System initialization" 8
echo

# Main Application Loop
while true; do
    display_main_menu
done
