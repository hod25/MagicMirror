#!/bin/sh

set -e

function finish {
  docker.logout
}
trap finish EXIT

branch=${1}

dest="--destination ${DOCKER_USER}/magicmirror:${branch}_alpine"
if [ "${branch}" = "master" ]; then
  dest="${dest} --destination ${DOCKER_USER}/magicmirror:alpine"
fi

docker.login

/kaniko/executor --context ./build \
  --dockerfile Dockerfile-alpine \
  ${dest} \
  --build-arg BUILDER_IMG=${DOCKER_USER}/magicmirror:${branch}_amd64
