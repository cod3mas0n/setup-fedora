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
: "${USE_THEME_TRANSPARENCY:=false}" # true/false
: "${VISIBLE_NAME:="Automated Profile"}"
: "${AUDIBLE_BELL:=false}"
: "${BOLD_IS_BRIGHT:=false}"

# Check required commands exist
command -v gsettings >/dev/null 2>&1 || { echo "gsettings not found. Install dconf-cli/gsettings."; exit 1; }

# Determine profile ID: use env PROFILE_ID if set, otherwise use GNOME Terminal default profile.
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
echo " Transparency: $TRANSPARENCY%"
echo

# Helper to run gsettings set for the profile path
gset() {
  local key="$1"; shift
  # Use printf %q to get proper quoting when necessary (shell passes final argument to gsettings)
  gsettings set "${PROFILE_PATH}" "${key}" "$@"
}

# Apply settings
echo " -> setting font and system font preference..."
gsettings set "${PROFILE_PATH}" "use-system-font" "${USE_SYSTEM_FONT}"
# Font value must be a string like 'Fira Code 12'
gsettings set "${PROFILE_PATH}" "font" "${FONT}"

echo " -> colors..."
gsettings set "${PROFILE_PATH}" "foreground-color" "${FOREGROUND}"
gsettings set "${PROFILE_PATH}" "background-color" "${BACKGROUND}"

echo " -> transparency..."
gsettings set "${PROFILE_PATH}" "use-theme-transparency" "${USE_THEME_TRANSPARENCY}"
gsettings set "${PROFILE_PATH}" "background-transparency-percent" "$(printf '%d' "${TRANSPARENCY}")"

echo " -> other preferences..."
gsettings set "${PROFILE_PATH}" "visible-name" "${VISIBLE_NAME}"
gsettings set "${PROFILE_PATH}" "audible-bell" "${AUDIBLE_BELL}"
gsettings set "${PROFILE_PATH}" "bold-is-bright" "${BOLD_IS_BRIGHT}"
gsettings set "${PROFILE_PATH}" "use-theme-colors" "false"  # let our explicit colors be used

# Print final values for verification
echo
echo "Applied profile settings (verification):"
gsettings list-recursively "${PROFILE_PATH}" | sed -n '1,120p'

echo
echo "Done."
