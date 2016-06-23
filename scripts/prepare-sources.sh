#!/bin/bash
set -e

# Skip the boring part
set +x

# Read positional arguments
SOURCE_DIR="$1"
GIT_BRANCH="$2"
shift; shift

# Read flags
while [[ $# -gt 0 ]]; do
  [[ "$1" == '--preserve' ]] && PRESERVE_SOURCE_DIR="yes"
  shift
done

# Ensure mandatory arguments are set
if [[ -z "$SOURCE_DIR" || -z "$GIT_BRANCH" ]]; then
  echo "Usage: $0 <target sources dir> <git branch> [--preserve]" >&2
  exit 1
fi

# Ensure optional parameters defaults are set
[[ -z "$REPO" ]] && REPO="https://code.qt.io/qt/qt5.git"

# Enable tracing for interestin stuff
set -x

# Prepare source directory
[[ -z "$PRESERVE_SOURCE_DIR" ]] && rm -rf "$SOURCE_DIR"/* "$SOURCE_DIR"/.[^.] "$SOURCE_DIR"/.??*
mkdir -p "$SOURCE_DIR"
cd "$SOURCE_DIR"

clone() {
  git clone --depth 1 --recurse-submodules --branch "$GIT_BRANCH" "$REPO" "$SOURCE_DIR"
}

# Clone and checkout sources
if [[ "$PRESERVE_SOURCE_DIR" == "yes" ]]; then
  if ! clone; then
    echo "Clone failed, but it's ok; will do fetch + reset instead!"
    git fetch --depth=1 --recurse-submodules
    git update-ref "refs/heads/$GIT_BRANCH" "origin/$GIT_BRANCH"
    git reset --hard "$GIT_BRANCH"
  fi
else
  clone
fi

# Clone submodules and do other initialization
./init-repository -f
