.PHONY: build publish release

VERSION := $(shell cat VERSION)

export DOCKER_REGISTRY ?=

export SUFFIX ?= $(VERSION)
export CPU_ENVIRONMENT_NAME := determinedai/environments:py-3.6.9-pytorch-1.4-tf-1.14-cpu
export GPU_ENVIRONMENT_NAME := determinedai/environments:cuda-10-py-3.6.9-pytorch-1.4-tf-1.14-gpu
CPU_ENVIRONMENT_NAME_SUFFIXED := $(CPU_ENVIRONMENT_NAME)-$(SUFFIX)
GPU_ENVIRONMENT_NAME_SUFFIXED := $(GPU_ENVIRONMENT_NAME)-$(SUFFIX)

build:
	docker build -f Dockerfile.cpu \
		-t $(DOCKER_REGISTRY)$(CPU_ENVIRONMENT_NAME) \
		-t $(DOCKER_REGISTRY)$(CPU_ENVIRONMENT_NAME_SUFFIXED) \
		.
	docker build -f Dockerfile.gpu \
		-t $(DOCKER_REGISTRY)$(GPU_ENVIRONMENT_NAME) \
		-t $(DOCKER_REGISTRY)$(GPU_ENVIRONMENT_NAME_SUFFIXED) \
		.

publish:
	docker push $(DOCKER_REGISTRY)$(CPU_ENVIRONMENT_NAME)
	docker push $(DOCKER_REGISTRY)$(CPU_ENVIRONMENT_NAME_SUFFIXED)
	docker push $(DOCKER_REGISTRY)$(GPU_ENVIRONMENT_NAME)
	docker push $(DOCKER_REGISTRY)$(GPU_ENVIRONMENT_NAME_SUFFIXED)

release: PART?=patch
release:
	bumpversion --current-version $(VERSION) $(PART)

# Timeout used by packer for AWS operations. Default is 120 (30 minutes) for
# waiting for AMI availablity. Bump to 180 attempts = 45 minutes.
export AWS_MAX_ATTEMPTS=180

build-vm:
	cd cloud && packer build environments-packer.json
