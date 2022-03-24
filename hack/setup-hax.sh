#!/bin/bash

DATA_DIR="${DATA_DIR:-data}"

if [ ! -f "${DATA_DIR}/auth.yaml" ]; then
  cat > "${DATA_DIR}/auth.yaml" << EOF
foo:
EOF
fi
