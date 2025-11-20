## —— Programming ----------------------------------------------------------------------------------

# https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions

VSCODE_REPO_PATH := etc/yum.repos.d/vscode.repo
.PHONY: vscode
vscode: ## Install and Configure VSCode
	@echo "## —— Installing Microsoft Vscode ------------------------------------------------------------------"
	@sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	sudo ln -fs ${PWD}/${VSCODE_REPO_PATH} /${VSCODE_REPO_PATH}
	@sudo dnf check-update -y
	@sudo dnf update -y
	@sudo dnf install -y code

GOLANG_VERSION := go1.25.4.linux-amd64.tar.gz
.PHONY: golang
golang: ## Install Golang
	@echo "## —— Installing Golang ----------------------------------------------------------------------------"
	@sudo rm -rf /tmp/${GOLANG_VERSION}
	sudo curl -fSL https://go.dev/dl/${GOLANG_VERSION} -o /tmp/${GOLANG_VERSION}
	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/${GOLANG_VERSION}

POSTMAN_DESKTOP_ENTRY := usr/share/applications/postman.desktop
.PHONY: postman
postman: ## Install Postman
	@echo "## —— Installing Postman ---------------------------------------------------------------------------"
	sudo curl -fSL https://dl.pstmn.io/download/latest/linux_64 -o /opt/postman-linux-x64.tar.gz
	@sudo tar -C /opt -xzf /opt/postman-linux-x64.tar.gz
	sudo ln -sf ${PWD}/${POSTMAN_DESKTOP_ENTRY} /${POSTMAN_DESKTOP_ENTRY}
