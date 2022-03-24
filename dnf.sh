#!/bin/bash

dnf -y install \
    make \
    gcc \
    wget \
    git \
    tar \
    tox \
    python3.7 \
    python3.8 \
    libcurl-devel \
    libxml2-devel \
    openssl-devel && \
    if [[ ! -z "$DEVELOPMENT" ]]; then \
      dnf -y install $DEV_PKGS; \
    else \
      dnf -y clean all; \
    fi
