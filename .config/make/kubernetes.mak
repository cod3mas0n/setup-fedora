## —— Kubernetes Tools -----------------------------------------------------------------------------

.PHONY: k8s-lens
k8s-lens: ## Install Lens IDE
	echo "## —— Installing Kubernetes Lens IDE ---------------------------------------------------------------"
	sudo dnf config-manager addrepo --overwrite --from-repofile=https://downloads.k8slens.dev/rpm/lens.repo
	sudo dnf install -y lens

FREE_LENS_LATEST := https://api.github.com/repos/freelensapp/freelens/releases/latest
.PHONY: k8s-free-lens
k8s-free-lens: ## Install FreeLens IDE
	echo "## —— Installing Kubernetes FreeLens IDE -----------------------------------------------------------"
	curl -x "socks5://127.0.0.1:10808" -fSL ${FREE_LENS_LATEST} \
	| grep "browser_download_url" \
	| grep -E 'linux-amd64\.rpm"' \
	| grep -v '\.sha256' \
	| cut -d '"' -f 4 \
	| head -n 1 \
	| xargs sudo curl -x "socks5://127.0.0.1:10808" -fSL -o /tmp/freelens-linux-amd64.rpm
	sudo rpm --force -Uvh /tmp/freelens-linux-amd64.rpm


KUBERNETES_REPO_PATH := etc/yum.repos.d/kubernetes.repo
.PHONY: kubectl
kubectl: ## Install Kubectl CLI
	echo "## —— Installing Kubectl ---------------------------------------------------------------------------"
	sudo ln -fs ${PWD}/${KUBERNETES_REPO_PATH} /${KUBERNETES_REPO_PATH}
	sudo dnf install -y kubectl

.PHONY: kubectx
kubectx: ## Install Kubernetes Context Switcher (Kubectx)
	echo "## —— Installing Kubectx/Kubens --------------------------------------------------------------------"
	sudo rm -rf /opt/kubectx &> /dev/null | true
	sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
	sudo ln -fs /opt/kubectx/kubectx /usr/local/bin/kubectx
	sudo ln -fs /opt/kubectx/kubens /usr/local/bin/kubens

.PHONY: helm
helm: ## Install K8S Package Manager (Helm)
	echo "## —— Installing Kubernetes Helm Package Manager ---------------------------------------------------"
	sudo dnf install -y helm
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
