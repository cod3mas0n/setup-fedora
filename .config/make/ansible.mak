## —— Ansible --------------------------------------------------------------------------------------

ANSIBLE_CFG_PATH := etc/ansible/ansible.cfg
ANSIBLE_PLUINGS_DIR := /etc/ansible/plugins
MITOGEN_VERSION := 0.3.33
MITOGEN_DOWNLOAD_URL := https://files.pythonhosted.org/packages/source/m/mitogen/mitogen-${MITOGEN_VERSION}.tar.gz


.PHONY: ansible
ansible: ## Install and Configure Ansible
	echo "## —— Installing and configuring Ansible -----------------------------------------------------------"
	sudo dnf install -y ansible ansible-lint ansible-galaxy
	sudo mv /${ANSIBLE_CFG_PATH} /${ANSIBLE_CFG_PATH}.bak &> /dev/null | true
	sudo ln -fs ${PWD}/${ANSIBLE_CFG_PATH} /${ANSIBLE_CFG_PATH}

	sudo mkdir -p ${ANSIBLE_PLUINGS_DIR}

# https://mitogen.networkgenomics.com/ansible_detailed.html#installation
.PHONY: ansible-mitogen
ansible-mitogen: ansible ## Install and Configure Ansible Mitogen
	echo "## —— Installing and configuring Ansible Mitogen ---------------------------------------------------"
	sudo curl -fSL ${MITOGEN_DOWNLOAD_URL} -o ${ANSIBLE_PLUINGS_DIR}/mitogen-${MITOGEN_VERSION}.tar.gz
	pushd ${ANSIBLE_PLUINGS_DIR} &> /dev/null && \
		sudo tar xzf mitogen-${MITOGEN_VERSION}.tar.gz && \
		popd &> /dev/null
	sudo sed -i --follow-symlinks "s|^strategy_plugins=.*/mitogen-[0-9.]\+/ansible_mitogen/plugins/strategy|strategy_plugins=/etc/ansible/plugins/mitogen-${MITOGEN_VERSION}/ansible_mitogen/plugins/strategy|" /${ANSIBLE_CFG_PATH}
