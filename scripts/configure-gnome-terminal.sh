#! /bin/bash

set -e
set -o nounset                # unset variables as an error
set -o pipefail               # makes sure a pipeline fails if any command in the chain fails.

# Usage:
#   FONT="Fira Code 12" BACKGROUND="#0b0f14" FOREGROUND="#cfe8ff" \
#     TRANSPARENCY=10 ./scripts/configure-gnome-terminal.sh
#
# You can override PROFILE_ID if you want to target a non-default profile:
#   PROFILE_ID="b1dcc9dd-...-xxxx" ./scripts/configure-gnome-terminal.sh

# Defaults (override via env)
: "${FONT:="Fira Code 15"}"
: "${BACKGROUND:="#171421"}"
: "${FOREGROUND:="#D0CFCC"}" # Text Color
: "${USE_SYSTEM_FONT:=false}" # true/false
: "${TRANSPARENCY:=0}"        # 0..100 (percent)
# : "${USE_THEME_TRANSPARENCY:=false}" # true/false
: "${VISIBLE_NAME:="Automated Profile"}"
: "${AUDIBLE_BELL:=false}"
: "${BOLD_IS_BRIGHT:=false}"
: "${WINDOWS_COLUMNS_SIZE:=136}"
: "${WINDOWS_ROWS_SIZE:=28}"

# Check required commands exist
command -v gsettings >/dev/null 2>&1 || { echo "gsettings not found. Install gsettings."; exit 1; }

# Determine profile ID: use env PROFILE_ID if set,
# Otherwise use GNOME Terminal default profile.
if [[ -z "${PROFILE_ID:-}" ]]; then
  # returns a quoted UUID like "'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'"
  PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
  if [[ -z "$PROFILE_ID" ]]; then
    echo "Unable to find GNOME Terminal default profile. Exiting."
    exit 1
  fi
fi

PROFILE_PATH="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE_ID}/"

echo "Configuring GNOME Terminal profile: $PROFILE_ID"
echo " Profile path: $PROFILE_PATH"
echo " Font: $FONT"
echo " Background: $BACKGROUND"
echo " Foreground: $FOREGROUND"
# echo " Transparency: $TRANSPARENCY%"
echo

# Apply settings
echo " -> setting font and system font preference..."
gsettings set "${PROFILE_PATH}" "use-system-font" "${USE_SYSTEM_FONT}"
# Font value must be a string like 'Fira Code 15'
gsettings set "${PROFILE_PATH}" "font" "${FONT}"

echo " -> colors..."
gsettings set "${PROFILE_PATH}" "foreground-color" "${FOREGROUND}"
gsettings set "${PROFILE_PATH}" "background-color" "${BACKGROUND}"

# echo " -> transparency..."
# gsettings set "${PROFILE_PATH}" "use-theme-transparency" "${USE_THEME_TRANSPARENCY}"
# gsettings set "${PROFILE_PATH}" "background-transparency-percent" "$(printf '%d' "${TRANSPARENCY}")"

echo " -> other preferences..."
gsettings set "${PROFILE_PATH}" "visible-name" "${VISIBLE_NAME}"
gsettings set "${PROFILE_PATH}" "audible-bell" "${AUDIBLE_BELL}"
gsettings set "${PROFILE_PATH}" "bold-is-bright" "${BOLD_IS_BRIGHT}"
gsettings set "${PROFILE_PATH}" "use-theme-colors" "false"  # let our explicit colors be used

gsettings set "${PROFILE_PATH}" "default-size-columns" "${WINDOWS_COLUMNS_SIZE}"
gsettings set "${PROFILE_PATH}" "default-size-rows" "${WINDOWS_ROWS_SIZE}"

# Print final values for verification
# echo
# echo "Applied profile settings (verification):"
# gsettings list-recursively "${PROFILE_PATH}" | sed -n '1,120p'

echo
echo "Gnome Terminal Customization is Done."

# org.gnome.Terminal.Legacy.Profile audible-bell false
# org.gnome.Terminal.Legacy.Profile background-color 'rgb(23,20,33)'
# org.gnome.Terminal.Legacy.Profile backspace-binding 'ascii-delete'
# org.gnome.Terminal.Legacy.Profile bold-color '#000000'
# org.gnome.Terminal.Legacy.Profile bold-color-same-as-fg true
# org.gnome.Terminal.Legacy.Profile bold-is-bright false
# org.gnome.Terminal.Legacy.Profile cell-height-scale 1.0
# org.gnome.Terminal.Legacy.Profile cell-width-scale 1.0
# org.gnome.Terminal.Legacy.Profile cjk-utf8-ambiguous-width 'narrow'
# org.gnome.Terminal.Legacy.Profile cursor-background-color '#000000'
# org.gnome.Terminal.Legacy.Profile cursor-blink-mode 'system'
# org.gnome.Terminal.Legacy.Profile cursor-colors-set false
# org.gnome.Terminal.Legacy.Profile cursor-foreground-color '#ffffff'
# org.gnome.Terminal.Legacy.Profile cursor-shape 'block'
# org.gnome.Terminal.Legacy.Profile custom-command ''
# org.gnome.Terminal.Legacy.Profile default-size-columns 136
# org.gnome.Terminal.Legacy.Profile default-size-rows 28
# org.gnome.Terminal.Legacy.Profile delete-binding 'delete-sequence'
# org.gnome.Terminal.Legacy.Profile enable-bidi true
# org.gnome.Terminal.Legacy.Profile enable-shaping true
# org.gnome.Terminal.Legacy.Profile enable-sixel false
# org.gnome.Terminal.Legacy.Profile encoding 'UTF-8'
# org.gnome.Terminal.Legacy.Profile exit-action 'close'
# org.gnome.Terminal.Legacy.Profile font 'Fira Code 15'
# org.gnome.Terminal.Legacy.Profile foreground-color 'rgb(208,207,204)'
# org.gnome.Terminal.Legacy.Profile highlight-background-color '#000000'
# org.gnome.Terminal.Legacy.Profile highlight-colors-set false
# org.gnome.Terminal.Legacy.Profile highlight-foreground-color '#ffffff'
# org.gnome.Terminal.Legacy.Profile login-shell false
# org.gnome.Terminal.Legacy.Profile palette ['rgb(23,20,33)', 'rgb(192,28,40)', 'rgb(38,162,105)', 'rgb(162,115,76)', 'rgb(14,102,213)', 'rgb(163,71,186)', 'rgb(42,161,179)', 'rgb(208,207,204)', 'rgb(94,92,100)', 'rgb(246,97,81)', 'rgb(51,218,122)', 'rgb(233,173,12)', 'rgb(42,123,222)', 'rgb(192,97,203)', 'rgb(51,199,222)', 'rgb(255,255,255)']
# org.gnome.Terminal.Legacy.Profile preserve-working-directory 'safe'
# org.gnome.Terminal.Legacy.Profile rewrap-on-resize true
# org.gnome.Terminal.Legacy.Profile scroll-on-insert true
# org.gnome.Terminal.Legacy.Profile scroll-on-keystroke true
# org.gnome.Terminal.Legacy.Profile scroll-on-output false
# org.gnome.Terminal.Legacy.Profile scrollback-lines 10000
# org.gnome.Terminal.Legacy.Profile scrollback-unlimited false
# org.gnome.Terminal.Legacy.Profile scrollbar-policy 'always'
# org.gnome.Terminal.Legacy.Profile text-blink-mode 'always'
# org.gnome.Terminal.Legacy.Profile use-custom-command false
# org.gnome.Terminal.Legacy.Profile use-system-font false
# org.gnome.Terminal.Legacy.Profile use-theme-colors false
# org.gnome.Terminal.Legacy.Profile visible-name 'Unnamed'
# org.gnome.Terminal.Legacy.Profile word-char-exceptions @ms nothing
