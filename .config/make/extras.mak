## —— Extra ----------------------------------------------------------------------------------------

.PHONY: yt-dlp
yt-dlp: ## Install and Configure yt-dlp
	sudo dnf install -y yt-dlp yt-dlp-bash-completion
	if ! [ -d ~/Downloads/Youtube ];then mkdir ${HOME}/Downloads/Youtube ;fi
	ln -sf ${PWD}/extras/ytd-nopl.sh ${HOME}/Downloads/Youtube/ytd-nopl.sh
	chmod +x ${HOME}/Downloads/Youtube/ytd-nopl.sh

	ln -sf ${PWD}/extras/ytd-pl.sh ${HOME}/Downloads/Youtube/ytd-pl.sh
	chmod +x ${HOME}/Downloads/Youtube/ytd-pl.sh

ETC_CRONTAB_PATH := etc/crontab
.PHONY: crontab
crontab: ## Install Cronie and Add Custom Crontab Template
	echo "## —— Custom Crontab Template ----------------------------------------------------------------------"
	sudo dnf install -y cronie
	sudo cp /${ETC_CRONTAB_PATH} /opt/crontab.bak &> /dev/null | true
	sudo ln -sf ${PWD}/${ETC_CRONTAB_PATH} /${ETC_CRONTAB_PATH}
