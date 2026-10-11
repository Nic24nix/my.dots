
#!/usr/bin/env bash

set -Eeuo pipefail

# ============================================
#               my.dots installer
# ============================================

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DOTS_DIR="$REPO_DIR/dots"
CONFIG_DIR="$HOME/.config"

BACKUP_ROOT="$HOME/.local/share/my.dots/backups"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

COMPONENTS=(hypr waybar wofi cava)

# Colours
if [[ -t 1 ]]; then
    RESET='\033[0m'
    BOLD='\033[1m'
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    YELLOW='\033[0;33m'
    RED='\033[0;31m'
else
    RESET=''
    BOLD=''
    GREEN=''
    BLUE=''
    YELLOW=''
    RED=''
fi

info() {
    printf "${BLUE}[*]${RESET} %s\n" "$*"
}

success() {
    printf "${GREEN}[OK]${RESET} %s\n" "$*"
}

warning() {
    printf "${YELLOW}[!]${RESET} %s\n" "$*"
}

error() {
    printf "${RED}[ERROR]${RESET} %s\n" "$*" >&2
}

# --------------------------------------------
# Header
# --------------------------------------------

printf '\n'
printf "${BOLD}============================================${RESET}\n"
printf "${BOLD}              my.dots installer             ${RESET}\n"
printf "${BOLD}============================================${RESET}\n\n"

printf 'Repository: %s\n' "$REPO_DIR"
printf 'Backup:     %s\n\n' "$BACKUP_DIR"

# --------------------------------------------
# Validate repository
# --------------------------------------------

if [[ ! -d "$DOTS_DIR" ]]; then
    error "The dots directory was not found: $DOTS_DIR"
    exit 1
fi

for component in "${COMPONENTS[@]}"; do
    if [[ ! -d "$DOTS_DIR/$component" ]]; then
        error "Missing source directory: dots/$component"
        exit 1
    fi
done

# --------------------------------------------
# Confirm before changing anything
# --------------------------------------------

warning "Existing configurations will be backed up."
warning "The four configuration directories will then be replaced."
printf '\n'

read -r -p "Continue with installation? [y/N] " answer

case "$answer" in
    y|Y|yes|YES) ;;
    *)
        info "Installation cancelled. Nothing was changed."
        exit 0
        ;;
esac

# --------------------------------------------
# Create backup
# --------------------------------------------

mkdir -p "$BACKUP_DIR"

for component in "${COMPONENTS[@]}"; do
    target="$CONFIG_DIR/$component"

    if [[ -e "$target" || -L "$target" ]]; then
        info "Backing up $component..."

        cp -a -- "$target" "$BACKUP_DIR/$component"
        success "Backup saved: $component"
    else
        info "No existing configuration for $component."
    fi
done

# Record the repository and backup information
{
    printf 'Repository: %s\n' "$REPO_DIR"
    printf 'Date: %s\n' "$TIMESTAMP"
    printf 'Components: %s\n' "${COMPONENTS[*]}"
} > "$BACKUP_DIR/backup-info.txt"

success "Backup completed: $BACKUP_DIR"

# --------------------------------------------
# Install dotfiles
# --------------------------------------------

for component in "${COMPONENTS[@]}"; do
    source_dir="$DOTS_DIR/$component"
    target_dir="$CONFIG_DIR/$component"

    info "Installing $component..."

    # Remove the old directory or symlink.
    # Its contents have already been backed up.
    if [[ -e "$target_dir" || -L "$target_dir" ]]; then
        rm -rf -- "$target_dir"
    fi

    mkdir -p "$CONFIG_DIR"
    cp -a -- "$source_dir" "$target_dir"

    success "$component installed."
done

# --------------------------------------------
# Finish
# --------------------------------------------

printf '\n'
printf "${GREEN}${BOLD}============================================${RESET}\n"
printf "${GREEN}${BOLD}         Installation completed!             ${RESET}\n"
printf "${GREEN}${BOLD}============================================${RESET}\n\n"

printf 'Backup location:\n  %s\n\n' "$BACKUP_DIR"

printf 'Installed components: %s\n' "${COMPONENTS[*]}"
printf '\n'
info "Restart or reload the relevant applications to apply changes."

