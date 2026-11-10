## —— Help -----------------------------------------------------------------------------------------

.PHONY: help
help: ## Show this help
	awk '
		BEGIN {
			if (ENVIRON["TERM"] != "dumb" && !("NO_COLOR" in ENVIRON)) {
				escape = sprintf("%c", 27)
				bold = escape "[1m"
				green = escape "[32m"
				cyan = escape "[36m"
				reset = escape "[0m"
			}
			printf "Usage: %smake%s %s<target>%s\n", bold, reset, cyan, reset
		}
		/^## / {
			printf "\n%s%s%s\n", green, substr($$0, 4), reset
			next
		}
		/^[[:alnum:]_-]+:.*## / {
			split($$0, parts, ":")
			description = $$0
			sub(/^.*## /, "", description)
			printf "  %s%-30s%s %s\n", cyan, parts[1], reset, description
		}
	' $(MAKEFILE_LIST)
