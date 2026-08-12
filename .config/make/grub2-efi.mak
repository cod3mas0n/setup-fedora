## —— grub2-efi ------------------------------------------------------------------------------------

.PHONY: grub2-efi
grub2-efi: ## Configure grub2-efi
	echo "## —— Configuring grub2-efi ------------------------------------------------------------------------"
	sudo grep -q '^GRUB_TIMEOUT_STYLE=' /etc/default/grub \
		&& sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub \
		|| echo 'GRUB_TIMEOUT_STYLE=menu' | sudo tee -a /etc/default/grub >/dev/null
	sudo grep -q '^GRUB_TIMEOUT=' /etc/default/grub \
		&& sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=30/' /etc/default/grub \
		|| echo 'GRUB_TIMEOUT=30' | sudo tee -a /etc/default/grub >/dev/null
	sudo grub2-mkconfig -o /boot/grub2/grub.cfg
