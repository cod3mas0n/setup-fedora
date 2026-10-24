## —— DevOps Tools ---------------------------------------------------------------------------------

.PHONY: terraform
terraform: ## Install and Configure Terraform
	echo "## —— Installing and configuring Terraform ---------------------------------------------------------"
	sudo dnf install -y dnf-plugins-core
	sudo dnf config-manager addrepo --overwrite --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
	sudo dnf install -y terraform

.PHONY: mimirtool
mimirtool: ## Install and Configure Mimirtool
	echo "## —— Installing and configuring Mimirtool ---------------------------------------------------------"
	sudo curl -x "socks5://127.0.0.1:10808" -fSLo /tmp/mimirtool https://github.com/grafana/mimir/releases/latest/download/mimirtool-linux-amd64
	sudo install -m 555 /tmp/mimirtool /usr/local/bin/mimirtool

MC_URL := https://github.com/minio/mc/releases/download/RELEASE.2025-08-13T08-35-41Z/mc.linux-amd64.RELEASE.2025-08-13T08-35-41Z
.PHONY: minio-mc
minio-mc: ## Install and Configure MinIO Client (mc)
	echo "## —— Installing and configuring MinIO Client ------------------------------------------------------"
	rm -rf ${HOME}/.minio-binaries/mc &> /dev/null | true
	curl -x "socks5://127.0.0.1:10808" -fSL "${MC_URL}" --create-dirs -o ${HOME}/.minio-binaries/mc
	chmod +x ${HOME}/.minio-binaries/mc

# https://argo-cd.readthedocs.io/en/stable/cli_installation/#download-latest-stable-version
ARGOCD_LATEST := https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION
.PHONY: argocd
argocd: ## Install and Configure ArgoCD CLI
	echo "## —— Installing and configuring ArgoCD CLI --------------------------------------------------------"
	echo "Fetching latest Argo CD version..."
	$(eval ARGOCD_VERSION := $(shell curl -fsSL "${ARGOCD_LATEST}"))
	curl -x "socks5://127.0.0.1:10808" -fSL -o "/tmp/argocd-linux-amd64-v${ARGOCD_VERSION}" https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64
	sudo install -m 555 "/tmp/argocd-linux-amd64-v${ARGOCD_VERSION}" /usr/local/bin/argocd
