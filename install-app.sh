#!/bin/bash
set -euo pipefail

# ─── OS Detection & Package Manager Setup ────────────────────────────────────
detect_pkg_manager() {
    declare -A os_map=(
        ["/etc/debian_version"]="apt install -y"
        ["/etc/alpine-release"]="apk add"
        ["/etc/redhat-release"]="yum install -y"
        ["/etc/arch-release"]="pacman -S --noconfirm"
        ["/etc/fedora-release"]="dnf install -y"
    )

    # Check OS-specific files first
    for f in "${!os_map[@]}"; do
        if [[ -f "$f" ]]; then
            echo "sudo ${os_map[$f]}"
            return
        fi
    done

    # Special cases
    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo "brew install"
    elif [[ -n "$TERMUX_VERSION" ]]; then
        echo "pkg install -y"
    else
        echo "Unsupported OS" >&2
        return 1
    fi
}

# ─── Installation Function ───────────────────────────────────────────────────
install_apps() {
    local pkg_manager installer apps=("$@")
    pkg_manager=$(detect_pkg_manager) || return 1
    
    echo "Detected package manager: $pkg_manager"
    for app in "${apps[@]}"; do
        echo "Installing $app..."
        if ! $pkg_manager "$app"; then
            echo "Failed to install $app" >&2
            return 1
        fi
    done
}

# ─── Usage Example ───────────────────────────────────────────────────────────
# Define your app list (can also accept command-line arguments)
app_list=(git neofetch htop)

install_apps "${app_list[@]}"
