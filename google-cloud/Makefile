
SHELL := /usr/bin/env bash
ROOT := ${CURDIR}

.PHONY: help
help:
	@echo 'Usage:'
	@echo '    make create     Create or update GCP resources.'
	@echo '    make proxy      Create bastion ssh tunnel/proxy'
	@echo '    make teardown   Destroy all GCP resources.'
	@echo '    make validate   Check that installed resources work as expected.'
	@echo

# create/delete/validate targets
.PHONY: create
create:
	@$(ROOT)/scripts/create.sh

.PHONY: teardown
teardown:
	@$(ROOT)/scripts/destroy.sh

.PHONY: proxy
proxy:
	@$(ROOT)/scripts/proxy.sh

.PHONY: validate
validate:
	@${ROOT}/scripts/validate.sh