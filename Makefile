.EXPORT_ALL_VARIABLES:

.PHONY: pre-commit changelog release

# -include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

help/local:
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

help: help/local

hooks: ## Commit hooks setup
	@pre-commit install
	@pre-commit gc
	@pre-commit autoupdate

validate: ## Validate with pre-commit hooks
	@pre-commit run --all-files

changelog: ## Update changelog
	git-chglog -o CHANGELOG.md --next-tag `semtag final -s minor -o`
