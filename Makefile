.PHONY: all link unlink packages test help

all: packages ## Install core packages, then link configs
	@bash install.sh

link: ## Create symlinks for all configs
	@bash install.sh

unlink: ## Remove all managed symlinks
	@bash unlink.sh

packages: ## Install core tools using the system package manager
	@bash packages.sh

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  %-12s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

test: ## Check installer backups, idempotence and safe uninstall
	@bash tests/install.sh
