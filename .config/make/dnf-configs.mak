## —— dnf configuration ----------------------------------------------------------------------------

CUSTOM_DNF_CONFIGURATION_FILE := etc/dnf/libdnf5.conf.d/20-user-settings.conf
.PHONY: dnf5-conf
dnf5-conf: ## Customize and configure dnf
	echo "## —— Customizing dnf5 -----------------------------------------------------------------------------"
	sudo ln -fs ${PWD}/${CUSTOM_DNF_CONFIGURATION_FILE} /${CUSTOM_DNF_CONFIGURATION_FILE}

	sudo dnf update -y
	sudo dnf install -y dnf-plugins-core
