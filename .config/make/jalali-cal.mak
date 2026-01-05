## —— jalali calender ------------------------------------------------------------------------------

JALALI_CAL_DIR := /opt/jcal

.PHONY: jalali-cal
jalali-cal: ## Install Jalali Calendar (https://github.com/persiancal/jcal.git)
	sudo rm -rf ${JALALI_CAL_DIR} &> /dev/null | true
	echo "## —— Installing Jalali Calendar from source --------------------------------------------------------"
	sudo git clone https://github.com/persiancal/jcal.git ${JALALI_CAL_DIR}
	pushd ${JALALI_CAL_DIR}/sources &> /dev/null && \
		sudo ./autogen.sh && \
		sudo ./configure && \
		sudo $(MAKE) && \
		popd &> /dev/null
