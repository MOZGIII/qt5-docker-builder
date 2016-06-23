#!/bin/bash
set -e

# Skip the boring part
set +x

# Read positional arguments
SOURCE_DIR="$1"
GIT_BRANCH="$2"

# Ensure mandatory arguments are set
if [[ -z "$SOURCE_DIR" || -z "$GIT_BRANCH" ]]; then
  echo "Usage: $0 <target sources dir> <git branch>" >&2
  exit 1
fi

# Ensure optional parameters defaults are set
[[ -z "$REPO" ]] && REPO="https://code.qt.io/qt/qt5.git"

# Enable tracing for interestin stuff
set -x

# Prepare source directory
rm -rf "$SOURCE_DIR"/* "$SOURCE_DIR"/.[^.] "$SOURCE_DIR"/.??*
mkdir -p "$SOURCE_DIR"
cd "$SOURCE_DIR"

# Clone and checkout sources
git clone --depth 1 --recurse-submodules --branch "$GIT_BRANCH" "$REPO" "$SOURCE_DIR"

# Clone submodules and do other initialization
./init-repository -f
