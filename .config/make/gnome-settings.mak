## —— Gnome Settings -------------------------------------------------------------------------------

.PHONY: gnome-extras
gnome-extras: ## Remove Extra/useless Gnome Applications
	@echo "## —— Uninstalling Extra/unused packages in Gnome --------------------------------------------------"
	@sudo dnf remove -y \
		gnome-boxes gnome-maps \
		gnome-contacts rhythmbox gnome-weather \
		gnome-software

.PHONY: gnome-keyboard-shortcuts
gnome-keyboard-shortcuts: ## Apply Gnome Custom Keyboard Shortcuts
	@echo "## —— Gnome Keyboard Custom Shortcuts --------------------------------------------------------------"
	gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Ptyxis Terminal'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/usr/bin/ptyxis -T "Terminal" --new-window'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control><Alt>t'

.PHONY: gnome-launchers-shortcuts
gnome-launchers-shortcuts: ## Apply Gnome Custom Application Launchers Shortcuts
	@echo "## —— Gnome Launchers Shortcuts --------------------------------------------------------------------"
	gsettings set org.gnome.settings-daemon.plugins.media-keys home '<Super>e'
	gsettings set org.gnome.settings-daemon.plugins.media-keys email ['<Super>q']
	gsettings set org.gnome.settings-daemon.plugins.media-keys www ['<Super>w']
	gsettings set org.gnome.settings-daemon.plugins.media-keys search ['<Super>s']

.PHONY: gnome-interface-settings
gnome-interface-settings: ## Apply Gnome Custom Interface Settings

	@echo "## —— Gnome Interface settings ---------------------------------------------------------------------"
	gsettings set org.gnome.desktop.wm.preferences button-layout 'close,maximize,minimize:appmenu'

	gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

	gsettings set org.gnome.mutter dynamic-workspaces false
	gsettings set org.gnome.desktop.wm.preferences num-workspaces 5

.PHONY: gnome-power-settings
gnome-power-settings: ## Apply Gnome Custom Power Settings
	@echo "## —— Gnome Power Settings -------------------------------------------------------------------------"
	gsettings set org.gnome.desktop.interface show-battery-percentage true
	gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled true
	gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'suspend'
	gsettings set org.gnome.settings-daemon.plugins.power idle-dim true
	gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery true
	gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 900
	gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 30
	gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
	gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
	gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
