FROM fedora:35 as build-tools

ARG DEVELOPMENT=
ARG DEV_PKGS="which tree"

# rpms required for building and running test suites
RUN dnf -y install \
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

ARG workdir=/ocs-ci
WORKDIR $workdir

# Copy Python requirements
COPY requirements.txt requirements-dev.txt requirements-docs.txt registry_requirement.txt setup.py tox.ini ./

# Do python stuff!
ENV VIRTUAL_ENV=./venv
RUN python3.7 -m venv $VIRTUAL_ENV && \
    source venv/bin/activate && \
    pip install --upgrade pip setuptools && \
    pip install -r requirements-dev.txt && \
    pip install -r requirements-docs.txt
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Set up tox environments
RUN tox --notest -e py37,py38,py39,flake8,black

# Copy current project contents
# NOTE: A .dockerignore file makes this much faster
COPY . .

ENTRYPOINT [ "run-ci" ]
CMD ["--help"]
