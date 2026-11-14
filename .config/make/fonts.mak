## —— Fonts ----------------------------------------------------------------------------------------

.PHONY: fira-code-fonts
fira-code-fonts: ## Install FiraCode Fonts
	echo "## —— Installing FiraCode Fonts --------------------------------------------------------------------"
	sudo dnf install -y fira-code-fonts cascadia-fonts-all

PERSIAN_FONTS_URL := https://raw.githubusercontent.com/fzerorubigd/persian-fonts-linux/master/farsifonts.sh
.PHONY: persian-fonts
persian-fonts: ## Install Persian Fonts
	echo "## —— Installing Persian Fonts ---------------------------------------------------------------------"
	bash -c "$$(curl -x "$(SOCKS5_PROXY_URL)" -fsSL ${PERSIAN_FONTS_URL})"
