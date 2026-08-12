#!/usr/bin/env bash

set -euo pipefail

GRUB_DEFAULT="/etc/default/grub"

set_grub_option() {
    local key="$1"
    local value="$2"

    if sudo grep -q "^${key}=" "$GRUB_DEFAULT"; then
        sudo sed -i "s|^${key}=.*|${key}=${value}|" "$GRUB_DEFAULT"
    else
        echo "${key}=${value}" | sudo tee -a "$GRUB_DEFAULT" >/dev/null
    fi
}

echo "Configuring GRUB..."

set_grub_option "GRUB_TIMEOUT_STYLE" "menu"
set_grub_option "GRUB_TIMEOUT" "30"
set_grub_option "GRUB_DISABLE_SUBMENU" "true"
set_grub_option "GRUB_CMDLINE_LINUX" '"rhgb"'

echo "Regenerating GRUB configuration..."

sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo "GRUB configuration complete."
