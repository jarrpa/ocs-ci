FROM fedora:34 as build-tools

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
    openssl-devel
#    && dnf clean all

# HAX: Remove
RUN dnf -y install which tree

WORKDIR /ocs-ci

# Copy Python requirements
COPY requirements.txt requirements-dev.txt requirements-docs.txt registry_requirement.txt setup.py ./

# Do python stuff!
ENV VIRTUAL_ENV=./venv
RUN python3.7 -m venv $VIRTUAL_ENV && \
    source venv/bin/activate && \
    pip install --upgrade pip setuptools && \
    pip install -r requirements-dev.txt && \
    pip install -r requirements-docs.txt
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy current project contents
COPY . .

# HAX: Hold this for now...
#COPY bin/ bin/
#COPY conf/ conf/
#COPY docs/ docs/
#COPY external/ external/
#COPY hack/ hack/
#COPY ocs_ci/ ocs_ci/
#COPY tests/ tests/
#COPY .functional_ci_setup.py .editorconfig Jenkinsfile LICENSE MANIFEST.in Makefile README.md pytest.ini pytest_unittests.ini tox.ini ./

# Python linting
#RUN make lint

# Run unit tests
RUN make unit-tests

ENTRYPOINT [ "run-ci" ]
