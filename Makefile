.PHONY: all link unlink packages help

all: link packages ## Link configs and install packages

link: ## Create symlinks for all configs
	@bash install.sh

unlink: ## Remove all managed symlinks
	@bash unlink.sh

packages: ## Install required packages via paru
	@bash packages.sh

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  %-12s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
