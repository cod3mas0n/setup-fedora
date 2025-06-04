# Makefile

# Use config.mak to override any of the following variables.
# Do not make changes here.

SHELL := /bin/bash
.DEFAULT_GOAL := install-packages

.PHONY: all
all: dnf5-conf rpmfusion fonts install-packages remove-gnome-extras ansible virtualization proxychains-ng vscode terraform k8s-lens free-lens kubectx helm mimirtool minio-mc sing-box crontab postman hiddify extras end-message

.PHONY: dnf-configs
dnf-configs: dnf5-conf dnf5-conf-proxy rpmfusion

.PHONY: k8s-tools
k8s-tools: k8s-lens free-lens kubectx helm


.PHONY: fonts
fonts:
	sudo dnf install -y fira-code-fonts

CUSTOM_DNF_CONFIGURATION_FILE := etc/dnf/libdnf5.conf.d/20-user-settings.conf
.PHONY: dnf5-conf
dnf5-conf:
	sudo ln -fs ${PWD}/${CUSTOM_DNF_CONFIGURATION_FILE} /${CUSTOM_DNF_CONFIGURATION_FILE}

	@sudo dnf update -y
	@sudo dnf install -y dnf-plugins-core

.PHONY: rpmfusion
# the shell in $(shell rpm -E %fedora) is specific for makefile , to make it to use the shell
# main format is $(rpm -E %fedora)
# https://rpmfusion.org/Configuration
rpmfusion:
	@sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(shell rpm -E %fedora).noarch.rpm
	@sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(shell rpm -E %fedora).noarch.rpm

.PHONY: install-packages
install-packages:
	@sudo dnf group install -y development-tools
	@sudo dnf config-manager addrepo --overwrite --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
	@sudo dnf install -y python3-devel ruby-devel make cmake g++ gcc \
		ffmpeg-free smplayer vlc gnome-mpv mplayer \
		gimp gimp-data-extras telegram-desktop \
		gnome-extensions-app gnome-tweaks gnome-terminal gnome-terminal-nautilus \
		htop btop thunderbird remmina ipython3 \
		google-chrome-stable brave-browser chromium \
		unrar keepassxc libreoffice tldr most jq yq \
		cowsay sshpass gnupg2 curl wget tar bat fzf alien rpm-build \
		cronie libssh2 libayatana-appindicator3 libayatana-indicator-gtk3
# https://mitogen.networkgenomics.com/ansible_detailed.html#installation
ANSIBLE_CFG_PATH := etc/ansible/ansible.cfg
ANSIBLE_PLUINGS_DIR := /etc/ansible/plugins
MITOGEN_VERSION := 0.3.23
MITOGEN_DOWNLOAD_URL := https://files.pythonhosted.org/packages/source/m/mitogen/mitogen-${MITOGEN_VERSION}.tar.gz

.PHONY: ansible
ansible:
	@sudo dnf install -y ansible ansible-lint ansible-galaxy
	@sudo mv /${ANSIBLE_CFG_PATH} /${ANSIBLE_CFG_PATH}.bak &> /dev/null | true
	sudo ln -fs ${PWD}/${ANSIBLE_CFG_PATH} /${ANSIBLE_CFG_PATH}

	@sudo mkdir -p ${ANSIBLE_PLUINGS_DIR}
	sudo curl -fsSL ${MITOGEN_DOWNLOAD_URL} -o ${ANSIBLE_PLUINGS_DIR}/mitogen-${MITOGEN_VERSION}.tar.gz
	@pushd ${ANSIBLE_PLUINGS_DIR} &> /dev/null && \
		sudo tar xzf mitogen-${MITOGEN_VERSION}.tar.gz && \
		popd &> /dev/null
	@sudo sed -i "s|^strategy_plugins=.*/mitogen-[0-9.]\+/ansible_mitogen/plugins/strategy|strategy_plugins=/etc/plugins/mitogen-${MITOGEN_VERSION}/ansible_mitogen/plugins/strategy|" /${ANSIBLE_CFG_PATH}

# https://docs.fedoraproject.org/en-US/quick-docs/virtualization-getting-started/
.PHONY: virtualization
virtualization:
	@sudo dnf install -y @virtualization
	@sudo dnf group install -y --with-optional virtualization
	@sudo systemctl start libvirtd
	@sudo systemctl enable libvirtd
	@sudo usermod -aG qemu ${USER}
	@sudo id ${USER}

.PHONY: remove-gnome-extras
remove-gnome-extras:
	@sudo dnf remove -y gnome-boxes gnome-maps \
		gnome-contacts rhythmbox gnome-weather

PROXYCHAINS_DIR := /opt/proxychains-ng
.PHONY: proxychains-ng
proxychains-ng:
	@ sudo rm -rf ${PROXYCHAINS_DIR} &> /dev/null | true
	@sudo git clone https://github.com/rofl0r/proxychains-ng.git ${PROXYCHAINS_DIR}
	@pushd ${PROXYCHAINS_DIR} &> /dev/null && \
		sudo ./configure --prefix=/usr --sysconfdir=/etc && \
		sudo $(MAKE) && \
		sudo $(MAKE) install && \
		sudo $(MAKE) install-config && \
		popd &> /dev/null
	sudo ln -fs ${PWD}/etc/proxychains.conf /etc/proxychains.conf

# https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions

VSCODE_REPO_PATH := etc/yum.repos.d/vscode.repo
.PHONY: vscode
vscode:
	@sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	sudo ln -fs ${PWD}/${VSCODE_REPO_PATH} /${VSCODE_REPO_PATH}
	@sudo dnf -y check-update
	@sudo dnf install -y code

.PHONY: terraform
terraform:
	@sudo dnf install -y dnf-plugins-core
	@sudo dnf config-manager addrepo --overwrite --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
	@sudo dnf install -y terraform

.PHONY: k8s-lens
k8s-lens:
	@sudo dnf config-manager addrepo --overwrite --from-repofile=https://downloads.k8slens.dev/rpm/lens.repo
	@sudo dnf install -y lens

FREE_LENS_LATEST := https://api.github.com/repos/freelensapp/freelens/releases/latest
.PHONY: free-lens
free-lens:
	@echo "Fetching latest FreeLens..."
	curl -fsSL ${FREE_LENS_LATEST} \
	| grep "browser_download_url" \
	| grep -E 'linux-amd64\.rpm"' \
	| grep -v '\.sha256' \
	| cut -d '"' -f 4 \
	| head -n 1 \
	| xargs sudo curl -L -o /opt/freelens-linux-amd64.rpm
	@sudo rpm --force -Uvh /opt/freelens-linux-amd64.rpm


KUBERNETES_REPO_PATH := etc/yum.repos.d/kubernetes.repo
.PHONY: kubectl
kubectl:
	@sudo ln -fs ${PWD}/${KUBERNETES_REPO_PATH} /${KUBERNETES_REPO_PATH}
	@sudo dnf install -y kubectl

.PHONY: kubectx
kubectx:
	@sudo rm -rf /opt/kubectx &> /dev/null | true
	@sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
	sudo ln -fs /opt/kubectx/kubectx /usr/local/bin/kubectx
	sudo ln -fs /opt/kubectx/kubens /usr/local/bin/kubens

.PHONY: helm
helm:
	@sudo dnf install -y helm
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@helm repo update

.PHONY: mimirtool
mimirtool:
	sudo curl -fsSLo /opt/mimirtool https://github.com/grafana/mimir/releases/latest/download/mimirtool-linux-amd64
	@sudo mv /opt/mimirtool /usr/local/bin/mimirtool
	@sudo chmod +x /usr/local/bin/mimirtool


.PHONY: minio-mc
minio-mc:
	@rm -rf ${HOME}/.minio-binaries/mc &> /dev/null | true
	curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o ${HOME}/.minio-binaries/mc
	@chmod +x ${HOME}/.minio-binaries/mc

GOLANG_VERSION := go1.24.3.linux-amd64.tar.gz

.PHONY: golang
golang:
	@sudo rm -rf /opt/${GOLANG_VERSION}
	sudo curl -fsSL https://go.dev/dl/${GOLANG_VERSION} -o /opt/${GOLANG_VERSION}
	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /opt/${GOLANG_VERSION}

.PHONY: sing-box
sing-box:
	@sudo dnf config-manager addrepo --overwrite --from-repofile=https://sing-box.app/sing-box.repo
	@sudo dnf install -y sing-box

ETC_CRONTAB_PATH := etc/crontab
.PHONY: crontab
crontab:
	@sudo dnf install -y cronie
	@sudo mv ${ETC_CRONTAB_PATH} /opt/${ETC_CRONTAB_PATH}.bak &> /dev/null | true
	sudo ln -sf ${PWD}/${ETC_CRONTAB_PATH} /${ETC_CRONTAB_PATH}

POSTMAN_DESKTOP_ENTRY := usr/share/applications/postman.desktop
.PHONY: postman
postman:
	sudo curl -fsSL https://dl.pstmn.io/download/latest/linux_64 -o /opt/postman-linux-x64.tar.gz
	@sudo tar -C /opt -xzf /opt/postman-linux-x64.tar.gz
	sudo ln -sf ${PWD}/${POSTMAN_DESKTOP_ENTRY} /${POSTMAN_DESKTOP_ENTRY}

NEKORAY_LATEST := https://api.github.com/repos/MatsuriDayo/nekoray/releases/latest
NEKORAY_DESKTOP_ENTRY := usr/share/applications/nekoray.desktop

.PHONY: nekoray
nekoray:
	@sudo mkdir -p /opt/nekoray
	@echo "Fetching latest Nekoray release URL..."
	curl -fsSL ${NEKORAY_LATEST} \
	| grep "browser_download_url" \
	| grep -E "linux64.zip" \
	| cut -d '"' -f 4 \
	| head -n 1 \
	| tee /tmp/nekoray_url.txt && \
	\
	pushd /opt/nekoray &> /dev/null && \
	sudo curl -LO "$$(cat /tmp/nekoray_url.txt)" && \
	\
	zipfile="$$(basename $$(cat /tmp/nekoray_url.txt))" && \
	sudo unzip -o "$$zipfile" && \
	sudo rm -rf /usr/lib64/nekoray &> /dev/null | true && \
	sudo mv /opt/nekoray/nekoray /usr/lib64/ && \
	popd &> /dev/null && \
	echo "Nekoray installed in /usr/lib64/nekoray "

	sudo ln -fs ${PWD}/${NEKORAY_DESKTOP_ENTRY} /${NEKORAY_DESKTOP_ENTRY}

HIDDIFY_LATEST := https://api.github.com/repos/hiddify/hiddify-next/releases/latest

.PHONY: hiddify
hiddify:
	@echo "Fetching latest Hiddify release URL..."
	curl -fsSL ${HIDDIFY_LATEST} \
	| grep "browser_download_url" \
	| grep -E "Hiddify-rpm-x64.rpm" \
	| cut -d '"' -f 4 \
	| xargs sudo curl -L -o /opt/Hiddify-rpm-x64.rpm
	@sudo rpm -Uvh /opt/Hiddify-rpm-x64.rpm

.PHONY: extras
extras:
	@echo "Linking Extras, like ytd, custom scripts."
	@if ! [ -d ~/Downloads/Youtube ];then mkdir ${HOME}/Downloads/Youtube ;fi
	ln -f ${PWD}/extras/ytd-nopl.sh ${HOME}/Downloads/Youtube/ytd-nopl.sh
	@chmod +x ${HOME}/Downloads/Youtube/ytd-nopl.sh
	ln -f ${PWD}/extras/ytd-pl.sh ${HOME}/Downloads/Youtube/ytd-pl.sh
	@chmod +x ${HOME}/Downloads/Youtube/ytd-pl.sh


.PHONY: end-message
end-message:
	@echo "All packages and Applications has been Installed Successfully."
