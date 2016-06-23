#!/bin/bash
set -e

# Skip the boring part
set +x

# Read positional arguments
SOURCE_DIR="$1"
BUILD_DIR="$2"

# Ensure mandatory arguments are set
if [[ -z "$SOURCE_DIR" || -z "$BUILD_DIR" ]]; then
  echo "Usage: $0 <sources dir> <target build dir>" >&2
  exit 1
fi

# SEnabled tracing for interestin stuff
set -x

# Prepare build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Build the code
"$SOURCE_DIR/configure" -developer-build -opensource -confirm-license -nomake examples -nomake tests
make -j"$(nproc)"
