#! /bin/bash

set -e
set -o nounset                # unset variables as an error
set -o pipefail               # makes sure a pipeline fails if any command in the chain fails.

# Usage:
#   FONT="Fira Code 12" WINDOWS_COLUMNS_SIZE='uint32 120'\
#     WINDOWS_ROWS_SIZE='uint32 24' ./scripts/configure-ptyxis-terminal.sh
#
# You can override PROFILE_PATH if you want to target a non-default profile:
#   PROFILE_PATH="/" ./scripts/configure-gnome-terminal.sh

# Defaults (override via env)
: "${FONT:="Fira Code 14"}"
: "${USE_SYSTEM_FONT:=false}" # true/false
: "${AUDIBLE_BELL:=false}"
: "${PALETTE:='Brogrammer'}"

# Check required commands exist
command -v gsettings >/dev/null 2>&1 || { echo "gsettings not found. Install gsettings."; exit 1; }

PROFILE_PATH="/"
PROFILE_ID=$(gsettings get org.gnome.Ptyxis default-profile-uuid)

echo "Configuring Ptyxis Terminal profile: $PROFILE_ID"
echo " Profile path: $PROFILE_PATH"
echo " Font: $FONT"
echo

# Apply Preferences
echo " -> setting font preference..."
gsettings set org.gnome.Ptyxis audible-bell "${AUDIBLE_BELL}"
gsettings set org.gnome.Ptyxis cursor-blink-mode 'system'
gsettings set org.gnome.Ptyxis cursor-shape 'block'
gsettings set org.gnome.Ptyxis default-columns 'uint32 120'
gsettings set org.gnome.Ptyxis default-rows 'uint32 24'
gsettings set org.gnome.Ptyxis disable-padding false
gsettings set org.gnome.Ptyxis enable-a11y true
gsettings set org.gnome.Ptyxis font-name "${FONT}"
gsettings set org.gnome.Ptyxis ignore-osc-title false
gsettings set org.gnome.Ptyxis interface-style 'dark'
gsettings set org.gnome.Ptyxis new-tab-position 'last'
gsettings set org.gnome.Ptyxis prompt-on-close true
gsettings set org.gnome.Ptyxis restore-session true
gsettings set org.gnome.Ptyxis restore-window-size false
gsettings set org.gnome.Ptyxis scrollbar-policy 'system'
gsettings set org.gnome.Ptyxis tab-middle-click 'close'
gsettings set org.gnome.Ptyxis text-blink-mode 'always'
gsettings set org.gnome.Ptyxis toast-on-copy-clipboard true
gsettings set org.gnome.Ptyxis use-system-font "${USE_SYSTEM_FONT}"
gsettings set org.gnome.Ptyxis visual-bell false
gsettings set org.gnome.Ptyxis visual-process-leader true
gsettings set org.gnome.Ptyxis word-char-exceptions '@ms nothing'

# Apply Profile
echo " -> setting up default profile..."
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" backspace-binding 'ascii-delete'
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" bold-is-bright false
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" cell-height-scale 1.0
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" cjk-ambiguous-width 'narrow'
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" custom-command ''
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" custom-links '@a(ss) []'
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" default-container 'session'
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" delete-binding 'delete-sequence'
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" exit-action 'close'
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" label ''
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" limit-scrollback true
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" login-shell false
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" opacity 1.0
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" palette "${PALETTE}"
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" preserve-container 'always'
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" preserve-directory 'safe'
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" scroll-on-keystroke true
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" scroll-on-output false
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" scrollback-lines 10000
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" use-custom-command false
gsettings set org.gnome.Ptyxis.Profile:"${PROFILE_PATH}" use-proxy true

# Apply Keyboard Shortcuts
echo " -> setting up shortcuts..."
gsettings set org.gnome.Ptyxis.Shortcuts close-other-tabs ''
gsettings set org.gnome.Ptyxis.Shortcuts close-tab '<ctrl><shift>w'
gsettings set org.gnome.Ptyxis.Shortcuts close-window '<ctrl><shift>q'
gsettings set org.gnome.Ptyxis.Shortcuts copy-clipboard '<ctrl><shift>c'
gsettings set org.gnome.Ptyxis.Shortcuts detach-tab ''
gsettings set org.gnome.Ptyxis.Shortcuts focus-tab-1 '<alt>1'
gsettings set org.gnome.Ptyxis.Shortcuts focus-tab-10 '<alt>0'
gsettings set org.gnome.Ptyxis.Shortcuts focus-tab-2 '<alt>2'
gsettings set org.gnome.Ptyxis.Shortcuts focus-tab-3 '<alt>3'
gsettings set org.gnome.Ptyxis.Shortcuts focus-tab-4 '<alt>4'
gsettings set org.gnome.Ptyxis.Shortcuts focus-tab-5 '<alt>5'
gsettings set org.gnome.Ptyxis.Shortcuts focus-tab-6 '<alt>6'
gsettings set org.gnome.Ptyxis.Shortcuts focus-tab-7 '<alt>7'
gsettings set org.gnome.Ptyxis.Shortcuts focus-tab-8 '<alt>8'
gsettings set org.gnome.Ptyxis.Shortcuts focus-tab-9 '<alt>9'
gsettings set org.gnome.Ptyxis.Shortcuts move-next-tab '<ctrl>Page_Down'
gsettings set org.gnome.Ptyxis.Shortcuts move-previous-tab '<ctrl>Page_Up'
gsettings set org.gnome.Ptyxis.Shortcuts move-tab-left '<ctrl><shift>Page_Up'
gsettings set org.gnome.Ptyxis.Shortcuts move-tab-right '<ctrl><shift>Page_Down'
gsettings set org.gnome.Ptyxis.Shortcuts new-tab '<ctrl><shift>t'
gsettings set org.gnome.Ptyxis.Shortcuts new-window '<ctrl><shift>n'
gsettings set org.gnome.Ptyxis.Shortcuts paste-clipboard '<ctrl><shift>v'
gsettings set org.gnome.Ptyxis.Shortcuts popup-menu '<shift>F10'
gsettings set org.gnome.Ptyxis.Shortcuts preferences '<ctrl>comma'
gsettings set org.gnome.Ptyxis.Shortcuts primary-menu 'F10'
gsettings set org.gnome.Ptyxis.Shortcuts reset ''
gsettings set org.gnome.Ptyxis.Shortcuts reset-and-clear ''
gsettings set org.gnome.Ptyxis.Shortcuts search '<ctrl><shift>f'
gsettings set org.gnome.Ptyxis.Shortcuts select-all '<ctrl><shift>a'
gsettings set org.gnome.Ptyxis.Shortcuts select-none ''
gsettings set org.gnome.Ptyxis.Shortcuts set-title ''
gsettings set org.gnome.Ptyxis.Shortcuts tab-menu '<alt>comma'
gsettings set org.gnome.Ptyxis.Shortcuts tab-overview '<ctrl><shift>o'
gsettings set org.gnome.Ptyxis.Shortcuts toggle-fullscreen 'F11'
gsettings set org.gnome.Ptyxis.Shortcuts undo-close-tab '<ctrl><shift><alt>t'
gsettings set org.gnome.Ptyxis.Shortcuts zoom-in '<ctrl>plus'
gsettings set org.gnome.Ptyxis.Shortcuts zoom-one '<ctrl>0'
gsettings set org.gnome.Ptyxis.Shortcuts zoom-out '<ctrl>minus'

echo
echo "Gnome Ptyxis Customization is Done."
