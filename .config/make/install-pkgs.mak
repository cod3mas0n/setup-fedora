## —— Package Installation -------------------------------------------------------------------------

# the shell in $(shell rpm -E %fedora) is specific for makefile , to make it to use the shell
# main format is $(rpm -E %fedora)

.PHONY: rpmfusion
rpmfusion: ## Install rpmfusion repositories (https://rpmfusion.org/Configuration)
	@echo "## —— Installing rpmfusion repositories ------------------------------------------------------------"

	@sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(shell rpm -E %fedora).noarch.rpm
	@sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(shell rpm -E %fedora).noarch.rpm

.PHONY: install-packages
install-packages: ## Install Essential Packages
	@echo "## —— Installing Essentials Packages ---------------------------------------------------------------"
	@sudo dnf install -y \
		gimp gimp-data-extras\
		htop remmina pwgen \
		unrar keepassxc \
		libreoffice tldr \
		most jq yq cowsay \
		gnupg2 curl wget tar \
		bat fzf alien rpm-build \
		cronie libssh2 sshpass \
		NetworkManager-libnm-devel \
		okular libgtop2-devel


.PHONY: install-devel-tools
install-devel-tools: ## Install Development tools Packages
	@echo "## —— installing development-tools -----------------------------------------------------------------"
	@sudo dnf group install -y development-tools
	@sudo dnf install -y \
		python3-devel ipython3 \
		ruby-devel \
		make cmake \
		g++ gcc

.PHONY: install-browsers
install-browsers: ## Install Web Browsers
	@echo "## —— installing Brave Browser Repo ----------------------------------------------------------------"
	@sudo dnf config-manager addrepo --overwrite --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
	@sudo dnf install -y \
		google-chrome-stable \
		brave-browser \
		chromium \

.PHONY: install-social-clients
install-social-clients: ## Install Social Clients
	@echo "## —— installing Social Clients --------------------------------------------------------------------"
	@sudo dnf install -y \
		telegram-desktop \
		thunderbird \
		discord

.PHONY: install-multimedia
install-multimedia: ## Install Browsers
	@echo "## —— installing Multimedia packages ---------------------------------------------------------------"
	@sudo dnf group install -y multimedia
	@sudo dnf install -y \
		ffmpeg-free \
		smplayer smplayer-themes smtube \
		vlc gnome-mpv mpv mplayer \
		cheese guvcview v4l-utils libwebcam \
		pavucontrol pulseaudio-utils \
		pipewire pipewire-pulse pipewire-alsa wireplumber

.PHONY: install-gnome-utils
install-gnome-utils: ## Install Gnome Utilities and Packages
	@echo "## —— installing development-tools -----------------------------------------------------------------"
	@sudo dnf group install -y development-tools
	@sudo dnf install -y \
		gnome-extensions-app gnome-extensions \
		gnome-terminal gnome-terminal-nautilus \
		gnome-themes-extra gnome-tweaks \
		libayatana-appindicator3 libayatana-indicator-gtk3 \
		gnome-system-monitor \
