#!/bin/bash

mkdir -p ./logs
mkdir -p ./data

if [ ! -f "data/auth.yaml" ]; then
  cat > data/auth.yaml << EOF
foo:
EOF
fi
