include hack/make-project-vars.mk

# Setting SHELL to bash allows bash commands to be executed by recipes.
# This is a requirement for 'setup-envtest.sh' in the test target.
# Options are set to exit when a recipe line exits non-zero or a piped command fails.
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

.DEFAULT_GOAL := help

all: build

##@ General

# The help target prints out all targets with their descriptions organized
# beneath their categories. The categories are represented by '##@' and the
# target descriptions by '##'. The awk commands is responsible for reading the
# entire set of makefiles included in this invocation, looking for lines of the
# file as xyz: ## something, and then pretty-format the target and help. Then,
# if there's a line with ##@ something, that gets pretty-printed as a category.
# More info on the usage of ANSI control characters for terminal formatting:
# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters
# More info on the awk command:
# http://linuxcommand.org/lc3_adv_awk.php

help: ## Display this help.
	@./hack/make-help.sh $(MAKEFILE_LIST)

##@ Development

IMG ?= quay.io/jarrpa/ocs-ci:jarrpa-dev

build: docker-build tox ## Build and test the ocs-ci container image

tox: ## Run local tests against the ocs-ci container image
	docker run --entrypoint tox ${IMG}

docker-build: ## Build ocs-ci container image
	docker build -t ${IMG} .

docker-push: ## Push ocs-ci container image
	docker push ${IMG}

##@ Run

TESTS ?= deployment
DATA_DIR ?= ./data

AWS_DIR ?= ~/.aws
CLUSTER_NAME ?= jarrpa-dev
CLUSTER_PATH ?= /clusters/$(CLUSTER_NAME)
LOCAL_CLUSTER_PATH ?= ~/ocp/${CLUSTER_NAME}/aws-dev

run: ## Run an ocs-ci container instance
	docker run -v ${DATA_DIR}:/ocs-ci/data:ro \
		-v ${AWS_DIR}:/root/.aws:ro \
		-v ${LOCAL_CLUSTER_PATH}:${CLUSTER_PATH} \
		${IMG} \
		-m "$(TESTS)" --cluster-path=${CLUSTER_PATH} --cluster-name=${CLUSTER_NAME}

shell: ## Run a shell in an ocs-ci container instance
	docker run -v ${DATA_DIR}:/ocs-ci/data:ro \
		-v ${AWS_DIR}:/root/.aws:ro \
		-v ${LOCAL_CLUSTER_PATH}:${CLUSTER_PATH} \
		-it --entrypoint /bin/bash \
		${IMG}
