#!/usr/bin/env bash

set -euo pipefail

REPO_FILE="etc/yum.repos.d/kubernetes.repo"

# Get latest stable minor version (e.g. 1.37)
LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt | sed 's/v//' | cut -d. -f1-2)

# Get current version from the repo file
CURRENT=$(grep -oP 'v\K[0-9]+\.[0-9]+' "$REPO_FILE" | head -1)

if [[ -z "$CURRENT" ]]; then
    echo "Error: Could not detect current version in $REPO_FILE"
    exit 1
fi

if [[ "$LATEST" == "$CURRENT" ]]; then
    echo "→ Kubernetes repo is already up to date (v${CURRENT})"
    exit 0
fi

echo "→ Updating Kubernetes repo: v${CURRENT} → v${LATEST}"

# Replace both baseurl and gpgkey versions
sed -i "s|v${CURRENT}|v${LATEST}|g" "$REPO_FILE"

echo "✓ Updated $REPO_FILE to v${LATEST}"
