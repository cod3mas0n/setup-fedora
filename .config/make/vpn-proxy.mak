## —— VPN and Proxy --------------------------------------------------------------------------------

PROXYCHAINS_DIR := /opt/proxychains-ng

.PHONY: proxychains-ng
proxychains-ng: ## Install Proxychains-ng (https://github.com/rofl0r/proxychains-ng)
	sudo rm -rf ${PROXYCHAINS_DIR} &> /dev/null | true
	echo "## —— Installing Proxychains-ng from source --------------------------------------------------------"
	sudo git clone https://github.com/rofl0r/proxychains-ng.git ${PROXYCHAINS_DIR}
	pushd ${PROXYCHAINS_DIR} &> /dev/null && \
		sudo ./configure --prefix=/usr --sysconfdir=/etc && \
		sudo $(MAKE) && \
		sudo $(MAKE) install && \
		sudo $(MAKE) install-config && \
		popd &> /dev/null
	sudo ln -fs ${PWD}/etc/proxychains.conf /etc/proxychains.conf

.PHONY: sing-box
sing-box: ## Install sing-box (https://sing-box.sagernet.org/)
	echo "## —— Installing sing-box --------------------------------------------------------------------------"
	sudo dnf config-manager addrepo --overwrite --from-repofile=https://sing-box.app/sing-box.repo
	sudo dnf install -y sing-box

NEKORAY_LATEST := https://api.github.com/repos/MatsuriDayo/nekoray/releases/latest
NEKORAY_DESKTOP_ENTRY := usr/share/applications/nekoray.desktop

.PHONY: nekoray-client
nekoray-client: ## Install Nekoray (https://github.com/MatsuriDayo/nekoray)
	echo "## —— Installing Nekoray From Source ---------------------------------------------------------------"
	sudo mkdir -p /tmp/nekoray
	curl -fsSL ${NEKORAY_LATEST} \
	| grep "browser_download_url" \
	| grep -E "linux64.zip" \
	| cut -d '"' -f 4 \
	| head -n 1 \
	| tee /tmp/nekoray_url.txt && \
	\
	pushd /tmp/nekoray &> /dev/null && \
	sudo curl -fSLO "$$(cat /tmp/nekoray_url.txt)" && \
	\
	zipfile="$$(basename $$(cat /tmp/nekoray_url.txt))" && \
	sudo unzip -o "$$zipfile" && \
	sudo rm -rf /usr/lib64/nekoray &> /dev/null | true && \
	sudo mv /tmp/nekoray/nekoray /usr/lib64/ && \
	popd &> /dev/null && \

	sudo ln -fs ${PWD}/${NEKORAY_DESKTOP_ENTRY} /${NEKORAY_DESKTOP_ENTRY}

HIDDIFY_LATEST := https://api.github.com/repos/hiddify/hiddify-next/releases/latest

.PHONY: hiddify-client
hiddify-client: ## Install Hiddify (https://hiddify.com)
	echo "## —— Installing Hiddify Client -------------------------------------------------------------------"
	curl -fsSL ${HIDDIFY_LATEST} \
	| grep "browser_download_url" \
	| grep -E "Hiddify-rpm-x64.rpm" \
	| cut -d '"' -f 4 \
	| xargs sudo curl -fSL -o /tmp/Hiddify-rpm-x64.rpm
	sudo rpm -UFvh /tmp/Hiddify-rpm-x64.rpm

V2RAYN_LATEST := https://api.github.com/repos/2dust/v2rayN/releases/latest

.PHONY: v2rayn-client
v2rayn-client: ## Install V2rayN (https://github.com/2dust/v2rayN)
	echo "## —— Installing V2rayN Client --------------------------------------------------------------------"
	curl -fsSL ${V2RAYN_LATEST} \
	| grep "browser_download_url" \
	| grep -E "v2rayN-linux-rhel-64.rpm" \
	| cut -d '"' -f 4 \
	| xargs sudo curl -fSL -o /tmp/v2rayN-linux-rhel-64.rpm
	sudo rpm -UFvh /tmp/v2rayN-linux-rhel-64.rpm
