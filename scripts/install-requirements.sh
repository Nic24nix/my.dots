#!/bin/sh

# ==========================================
#          my.dots - Installer
# ==========================================

set -u

printf '\n'
printf '%s\n' '========================================'
printf '%s\n' '          my.dots Installer'
printf '%s\n' '========================================'
printf '\n'

# Check whether DNF is available
if ! command -v dnf >/dev/null 2>&1; then
    echo "Error: DNF was not found. Fedora is required."
    exit 1
fi

# Ask whether a dependency is installed
check_dependency() {
    name="$1"
    command_name="$2"
    package="$3"

    printf 'Do you already have %s installed? (y/n): ' "$name"
    read -r answer

    case "$answer" in
        y|Y|yes|YES)
            echo "$name: keeping the current installation."
            ;;
        n|N|no|NO)
            echo "Installing $name..."
            sudo dnf install "$package"
            ;;
        *)
            echo "Invalid answer. Skipping $name."
            ;;
    esac
}

check_dependency "Hyprland" "hyprland" "hyprland"
check_dependency "Cava" "cava" "cava"
check_dependency "Wofi" "wofi" "wofi"
check_dependency "Waybar" "waybar" "waybar"

printf '\n%s\n' 'Dependency check complete!'
