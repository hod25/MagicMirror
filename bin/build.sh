#!/bin/sh

set -e

function finish {
  docker.logout
}
trap finish EXIT

branch=${1}
imgarch=${2}

GitRepo="https://github.com/MichMich/MagicMirror.git"
MagicMirror_Version="v2.13.0"

if [ "${branch}" = "master" ]; then
  echo "branch is master"
  BuildRef=${MagicMirror_Version}
else
  echo "branch is not master"
  BuildRef=develop
fi
echo "MagicMirror-BuildRef="${BuildRef}

# set build arch
if [ "${imgarch}" = "arm" ]; then
  /register
  buildarch="arm32v7/"
elif [ ! "${imgarch}" = "amd64" ]; then
  echo "unsupported image arch: ${imgarch}"
fi

docker.gitlab.login

/kaniko/executor --context ./build \
  --dockerfile Dockerfile \
  --destination ${CI_REGISTRY_IMAGE}:${branch}_${imgarch} \
  --build-arg buildarch=${buildarch} \
  --build-arg BuildRef=${BuildRef} \
  --build-arg GitRepo=${GitRepo}

if [ "${branch}" = "master" ]; then
  docker.manifest ${CI_REGISTRY_IMAGE}:${branch} latest
  docker.manifest ${CI_REGISTRY_IMAGE}:${branch} ${MagicMirror_Version}
  docker.sync "${CI_REGISTRY_IMAGE}:latest ${CI_REGISTRY_IMAGE}:${MagicMirror_Version}"
else
  docker.manifest ${CI_REGISTRY_IMAGE}:${branch} ${branch}
  docker.sync "${CI_REGISTRY_IMAGE}:${branch}"
fi
