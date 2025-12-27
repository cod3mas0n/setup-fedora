.PHONY: all SHELL
all: vpn-proxy dnf-configs \
	fonts install-pkgs \
	gnome-settings \
	programming virtualization \
	devops-tools kubernetes-tools \
	extras crontab \

# Makefile global config
# Use config.mak to override any of the following variables.
# Do not make changes here.

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:
MAKEFLAGS += "-j$(NUM_CORES) -l$(NUM_CORES)"
MAKEFLAGS += --silent
SHELL:= /bin/bash
.SHELLFLAGS = -eu -o pipefail -c

# Makefile colors config
bold := $(shell tput bold)
normal := $(shell tput sgr0)
errorTitle := $(shell tput setab 1 && tput bold && echo '\n')
recommendation := $(shell tput setab 4)
underline := $(shell tput smul)
reset := $(shell tput -Txterm sgr0)
black := $(shell tput setaf 0)
red := $(shell tput setaf 1)
green := $(shell tput setaf 2)
yellow := $(shell tput setaf 3)
blue := $(shell tput setaf 4)
magenta := $(shell tput setaf 5)
cyan := $(shell tput setaf 6)
white := $(shell tput setaf 7)

define HEADER
How to use me:
	# To install and configure all targets
	${bold}make all${reset}

	# To install and configure one target
	${bold}make ${cyan}<target>${reset}

endef
export HEADER

-include $(addsuffix /*.mak, $(shell find .config/make -type d))

.PHONY: devops-tools
devops-tools: ansible ansible-mitogen \
	terraform mimirtool \
	minio-mc argocd

.PHONY: kubernetes-tools
kubernetes-tools: k8s-lens \
	k8s-free-lens \
	kubectl kubectx helm

.PHONY: programming
programming: vscode golang postman

.PHONY: virtualization
virtualization: qemu-kvm-virt

.PHONY: vpn-proxy
vpn-proxy: proxychains-ng sing-box \
	nekoray-client hiddify-client \
	v2rayn-client

.PHONY: gnome-settings
gnome-settings: install-pkgs fonts \
	gnome-extras \
	gnome-gtk4-settings \
	gnome-keyboard-shortcuts \
	gnome-launchers-shortcuts \
	gnome-interface-settings \
	gnome-power-settings \
	gnome-terminal \
	ptyxis-terminal

.PHONY: install-pkgs
install-pkgs: rpmfusion \
	install-packages install-devel-tools \
	install-browsers install-social-clients \
	install-multimedia install-gnome-utils

.PHONY: dnf-configs
dnf-configs: vpn-proxy dnf5-conf

.PHONY: fonts
fonts: fira-code-fonts persian-fonts

.PHONY: extras
extras: yt-dlp crontab
