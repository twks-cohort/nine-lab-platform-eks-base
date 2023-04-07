SHELL := /bin/bash
MAKE_FILE := $(lastword $(MAKEFILE_LIST))
CONTAINER_NAME ?= cohort-nine-module3
ACTION ?= plan
.PHONY: help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
CONTAINER_USER_HOMEDIR=/home/cohorts-nine
USER_UID ?= $(shell id -u)

help: ## Help
	@grep -E '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## destroy container
	docker image ls $(CONTAINER_NAME) -q | xargs docker rmi -f
	docker image prune --filter label=name=$(CONTAINER_NAME) -f
	docker image ls

lint-dockerfile: ## lint Dockerfile
	docker run --rm -v $$(pwd):/app -w /app -i hadolint/hadolint < Dockerfile

build: ## Build the docker image after linting the dockerfile 
	docker build -t $(CONTAINER_NAME):latest --build-arg CONTAINER_NAME=$(CONTAINER_NAME) --build-arg USER_UID=$(USER_UID) .
	docker image ls

define docker_run
	docker run --rm $1 \
	--memory="2g" --cpus="1.0" \
	-v $$(pwd):/project \
	-v $(HOME)/.aws:$(CONTAINER_USER_HOMEDIR)/.aws \
	-v $(HOME)/.terraform.d:$(CONTAINER_USER_HOMEDIR)/.terraform.d \
	-w /project \
	-e AWS_PROFILE=$(AWS_PROFILE) \
	$(CONTAINER_NAME):latest $2
endef

run: ## Run terraform inside the docker container
	$(call docker_run,-it,container-$(ACTION))

container-shell: ## Run terraform inside the docker container
	bash

container-aws-auth:
	aws configure sso

container-aws-login:
	aws sso login

container-login:
	terraform login

container-init:
	terraform init

container-plan:
	terraform plan

container_apply:
	terraform apply