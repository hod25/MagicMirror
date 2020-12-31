#!/bin/sh

set -e

function finish {
  docker.logout
}
trap finish EXIT

GitRepo="https://github.com/MichMich/MagicMirror.git"
MagicMirror_Version="v2.14.0"

if [ "${CI_COMMIT_BRANCH}" = "master" ]; then
  echo "CI_COMMIT_BRANCH is master"
  BuildRef=${MagicMirror_Version}
else
  echo "CI_COMMIT_BRANCH is not master"
  BuildRef=develop
fi
echo "MagicMirror-BuildRef="${BuildRef}

# set build arch
if [ "${imgarch}" = "arm" ]; then
  /register
  buildarch="arm32v7/"
elif [ "${imgarch}" = "arm64" ]; then
  /register
  buildarch="arm64v8/"
elif [ ! "${imgarch}" = "amd64" ]; then
  echo "unsupported image arch: ${imgarch}"
fi

BUILDER_IMG="${CI_REGISTRY_IMAGE}:${BuildRef}_${imgarch}_artifacts"
if [ "$(skopeo inspect docker://${BUILDER_IMG})" ] && [ "${CI_COMMIT_BRANCH}" = "master" ]; then
  echo "no builder image rebuild"
  BUILD_ARTIFACTS="false"
else
  echo "builder image (re)build"
  BUILD_ARTIFACTS="true"
fi

docker.gitlab.login

if [ "${BUILD_ARTIFACTS}" = "true" ]; then
  /kaniko/executor --context ./build \
    --dockerfile Dockerfile-artifacts \
    --destination ${BUILDER_IMG} \
    --build-arg buildarch=${buildarch} \
    --build-arg BuildRef=${BuildRef} \
    --build-arg GitRepo=${GitRepo}

  #cleanup kaniko
  rm -rf /kaniko/0
fi

/kaniko/executor --context ./build \
  --dockerfile Dockerfile-debian \
  --destination ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}_${imgarch} \
  --build-arg buildarch=${buildarch} \
  --build-arg BUILDER_IMG=${BUILDER_IMG}

if [ "${CI_COMMIT_BRANCH}" = "master" ]; then
  docker.manifest ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH} latest
  docker.manifest ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH} ${MagicMirror_Version}
  docker.sync "${CI_REGISTRY_IMAGE}:latest ${CI_REGISTRY_IMAGE}:${MagicMirror_Version}"
else
  docker.manifest ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH} ${CI_COMMIT_BRANCH}
  docker.sync "${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}"
fi

# alpine image
if [ "${imgarch}" = "amd64" ]; then
  #cleanup kaniko
  rm -rf /kaniko/0

  dest="--destination ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}_alpine"
  if [ "${CI_COMMIT_BRANCH}" = "master" ]; then
    dest="${dest} --destination ${CI_REGISTRY_IMAGE}:alpine"
  fi

  /kaniko/executor --context ./build \
    --dockerfile Dockerfile-alpine \
    ${dest} \
    --build-arg BUILDER_IMG=${BUILDER_IMG}

  if [ "${CI_COMMIT_BRANCH}" = "master" ]; then
    docker.sync "${CI_REGISTRY_IMAGE}:alpine"
  else
    docker.sync "${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}_alpine"
  fi
fi
