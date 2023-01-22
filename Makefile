SHELL := zsh
.ONESHELL:
.SHELL_FLAGS := -eu -o pipefail -c

YARN = node yarn

targets: help

done-server: lint, security, format

ci-docker-compose := docker-compose -f .ci/docker-compose.yml

format-server:
	black server/.
	isort server/.

check-server:
	black server/. --check --diff
	isort server/. --check --diff

lint-server:
	flake8 server/.

security-server:
	bandit -r server/.

build-sass:
	@$(YARN) sass

.PHONY: build-sass

build-front:
	@$(YARN) install;
	${MAKE} build-ts;
	${MAKE} build-sass;

.PHONY: build-front

build-ts:
	@$(YARN) build

.PHONY: build-ts

lint-front:
	${MAKE} lint-front-tslint;
	${MAKE} lint-front-prettier;

.PHONY: lint-front

lint-front-tslint:
	@$(YARN) lint

.PHONY: lint-front-tslint

lint-front-prettier:
	@$(YARN) prettier-write

.PHONY: lint-front-prettier

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help