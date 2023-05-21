SHELL = /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: pre-commit changelog release

# -include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

help/local:
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

help: help/local

hooks: ## Commit hooks setup
	@pre-commit install
	@pre-commit gc

validate: ## Validate with pre-commit hooks
	@pre-commit run --all-files

init: ## Test diff
	@terraform init

format: ## Terraform format
	@terraform format

cleanup: ## Clean resources
	@find . -type d -name ".terraform" -prune -exec rm -rf {} \;
	@find . -type f -name ".terraform.lock.hcl" -prune -exec rm  {} \;
