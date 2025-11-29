## —— Virtualization (QEMU/KVM) --------------------------------------------------------------------

# https://docs.fedoraproject.org/en-US/quick-docs/virtualization-getting-started/
.PHONY: qemu-kvm-virt
qemu-kvm-virt: ## Install Virtualization (QEMU/KVM)
	echo "## —— Installing Qemu/KVM Virtualization -----------------------------------------------------------"
	sudo dnf update -y
	sudo dnf install -y virtualization
	sudo dnf group install -y --with-optional virtualization
	sudo systemctl start libvirtd
	sudo systemctl enable libvirtd
	sudo usermod -aG qemu ${USER}
	sudo id ${USER}
