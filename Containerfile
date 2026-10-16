# Minimal, generic base for running work inside a Podman machine on macOS.
#
# On Apple Silicon the Podman machine is an aarch64 Linux VM, so this image is
# built and run natively. There is deliberately no qemu and no binfmt setup.

ARG BASE_IMAGE=alpine:latest
FROM ${BASE_IMAGE}

# Extra Alpine packages to add at build time, e.g.
#   podman build --build-arg EXTRA_PACKAGES="python3 py3-pip" .
# Packages come from main and community as configured in the base image.
ARG EXTRA_PACKAGES=""

RUN apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        git \
        make \
        tzdata \
    && if [ -n "${EXTRA_PACKAGES}" ]; then \
        apk add --no-cache ${EXTRA_PACKAGES}; \
    fi

ENV LANG=C.UTF-8
WORKDIR /work

CMD ["/bin/bash"]
