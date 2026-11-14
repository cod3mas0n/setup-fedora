.DEFAULT_GOAL := help
.ONESHELL:
.SILENT:
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

# Proxy settings are available to recipes without being enabled globally.
# Use `make USE_PROXY=1 ...` when a command needs the proxy environment.
PROXY_HOST ?= 127.0.0.1
PROXY_PORT ?= 10808
HTTP_PROXY_URL ?= http://$(PROXY_HOST):$(PROXY_PORT)
SOCKS5_PROXY_URL ?= socks5h://$(PROXY_HOST):$(PROXY_PORT)
USE_PROXY ?= 0
ifeq ($(USE_PROXY),1)
export http_proxy := $(HTTP_PROXY_URL)
export https_proxy := $(HTTP_PROXY_URL)
export HTTP_PROXY := $(HTTP_PROXY_URL)
export HTTPS_PROXY := $(HTTP_PROXY_URL)
endif

# Installation targets modify the system and should run sequentially by default.
# Avoid setting -j here; callers can choose their own make options.
include $(sort $(wildcard .config/make/*.mak))

## —— Main targets ---------------------------------------------------------------------------------

.PHONY: all devops-tools kubernetes-tools programming virtualization vpn-proxy \
	gnome-settings install-pkgs dnf-configs fonts extras grub2

all: ## Install and configure everything
all: vpn-proxy dnf-configs fonts install-pkgs gnome-settings \
	programming virtualization devops-tools kubernetes-tools extras crontab grub2

devops-tools: ansible ansible-mitogen terraform mimirtool minio-mc argocd ## Install DevOps tools

kubernetes-tools: k8s-lens k8s-free-lens kubectl kubectx helm ## Install Kubernetes tools

programming: vscode golang postman rustup trufflehog ## Install programming tools

virtualization: qemu-kvm-virt ## Install virtualization tools

vpn-proxy: proxychains-ng sing-box v2rayn-client throne ## Install VPN and proxy tools

gnome-settings: ## Configure GNOME
gnome-settings: install-pkgs fonts gnome-extras gnome-gtk4-settings \
	gnome-keyboard-shortcuts gnome-launchers-shortcuts gnome-interface-settings \
	gnome-power-settings gnome-terminal ptyxis-terminal gnome-better-tray

install-pkgs: ## Install packages
install-pkgs: rpmfusion install-packages install-devel-tools install-browsers \
	install-social-clients install-multimedia install-gnome-utils install-kepassxc

dnf-configs: vpn-proxy dnf5-conf ## Configure DNF

fonts: fira-code-fonts persian-fonts ## Install fonts

extras: yt-dlp crontab ## Install extras

grub2: grub2-efi ## Configure GRUB
