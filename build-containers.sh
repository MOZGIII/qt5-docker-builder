#!/bin/bash
set -e

: ${DOCKERFILES_DIR:="dockerfiles"}
: ${DOCKER_REPO_USER:="qt5builder"}

# Remove slashe at the end if is any
DOCKERFILES_DIR=${DOCKERFILES_DIR%/}

for distro_dir in "$DOCKERFILES_DIR"/*/; do
  distro_name=$(basename "$distro_dir")

  # `$distro_dir` has a shash at the end, so search in it
  # without adding extra slash: `..."$distro_dir"*...`
  for release_dir in "$distro_dir"*/; do
    release_name=$(basename "$release_dir")
    image_name="$DOCKER_REPO_USER/$distro_name-$release_name"
    echo "Building $image_name"
    docker build -t "$image_name" "$release_dir"
  done
done
