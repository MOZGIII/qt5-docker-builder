#!/bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read positional arguments
BUILDER_IMAGE_NAME="$1"
GIT_BRANCH="$2"
shift; shift

# Read flags
while [[ $# -gt 0 ]]; do
  [[ "$1" == '--preserve-source' ]] && PRESERVE_SOURCE_DIR="yes"
  [[ "$1" == '--no-preserve-source' ]] && PRESERVE_SOURCE_DIR="no"
  shift
done

# Ensure mandatory arguments are set
if [[ -z "$BUILDER_IMAGE_NAME" || -z "$GIT_BRANCH" ]]; then
  echo "Usage: $0 <builder image name> <qt git branch> [--preserve-source | --no-preserve-source]" >&2
  exit 1
fi

# Ensure optional parameters defaults are set
: ${SCRIPTS_DIR:="$DIR/scripts"}
: ${HOST_SOURCE_DIR:="$DIR/build/$GIT_BRANCH/$BUILDER_IMAGE_NAME"}
: ${DOCKER_SOURCE_DIR="/usr/src/qt"}

run_build_container() {
  docker run -it --rm --name "qt5-builder" -v "$SCRIPTS_DIR:/build-scripts" -v "$HOST_SOURCE_DIR:$DOCKER_SOURCE_DIR" $@
}

# Build optional args
[[ "$PRESERVE_SOURCE_DIR" == "yes" ]] && PREPARE_SOURCE_FLAGS="$PREPARE_SOURCE_FLAGS --preserve"

# Trace intersting stuff
set -x

mkdir -p $HOST_SOURCE_DIR
run_build_container "$BUILDER_IMAGE_NAME" /bin/bash "/build-scripts/prepare-sources.sh $DOCKER_SOURCE_DIR $GIT_BRANCH $PREPARE_SOURCE_FLAGS"
run_build_container "$BUILDER_IMAGE_NAME" /bin/bash "/build-scripts/build.sh $DOCKER_SOURCE_DIR $DOCKER_SOURCE_DIR"
