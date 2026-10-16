IMAGE ?= podman-libkrun-macos
TAG ?= latest
BASE_IMAGE ?= alpine:latest
EXTRA_PACKAGES ?=

.PHONY: build run push clean

build:
	podman build \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg EXTRA_PACKAGES="$(EXTRA_PACKAGES)" \
		--tag $(IMAGE):$(TAG) .

run:
	podman run --rm -it $(IMAGE):$(TAG)

push:
	podman push $(IMAGE):$(TAG)

clean:
	podman rmi $(IMAGE):$(TAG) || true
