#!/bin/sh

set -e

function finish {
  docker.logout
}
trap finish EXIT

branch=${1}

dest="--destination ${CI_REGISTRY_IMAGE}:${branch}_alpine"
if [ "${branch}" = "master" ]; then
  dest="${dest} --destination ${CI_REGISTRY_IMAGE}:alpine"
fi

docker.gitlab.login

/kaniko/executor --context ./build \
  --dockerfile Dockerfile-alpine \
  ${dest} \
  --build-arg BUILDER_IMG=${CI_REGISTRY_IMAGE}:${branch}_amd64

if [ "${branch}" = "master" ]; then
  docker.sync "${CI_REGISTRY_IMAGE}:alpine"
else
  docker.sync "${CI_REGISTRY_IMAGE}:${branch}_alpine"
fi
