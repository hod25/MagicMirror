#!/bin/sh

set -e

function finish {
  docker.logout
}
trap finish EXIT

GitRepo="https://github.com/MichMich/MagicMirror.git"
NODE_VERSION=${NODE_VERSION_MASTER}

if [ "${CI_COMMIT_BRANCH}" = "master" ]; then
  echo "CI_COMMIT_BRANCH is master"
  BuildRef=${MAGICMIRROR_VERSION}
  BuilderTag=${MAGICMIRROR_VERSION}
else
  echo "CI_COMMIT_BRANCH is not master"
  BuildRef="develop"
  BuilderTag=${CI_COMMIT_BRANCH}
  NODE_VERSION=${NODE_VERSION_DEVELOP}
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

BUILDER_IMG="${CI_REGISTRY_IMAGE}:${BuilderTag}_${imgarch}_artifacts"
if [ "$(skopeo inspect docker://${BUILDER_IMG})" ] && [ "${BuilderTag}" = "master" ]; then
  echo "no builder image rebuild"
  BUILD_ARTIFACTS="false"
else
  echo "builder image (re)build"
  BUILD_ARTIFACTS="true"
fi

docker.gitlab.login

if [ "${BUILD_ARTIFACTS}" = "true" ]; then
  build --context ./build \
    --dockerfile Dockerfile-artifacts \
    --destination ${BUILDER_IMG} \
    --build-arg NODE_VERSION=${NODE_VERSION} \
    --build-arg buildarch=${buildarch} \
    --build-arg BuildRef=${BuildRef} \
    --build-arg GitRepo=${GitRepo}
fi

build --context ./build \
  --dockerfile Dockerfile-debian \
  --destination ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}_${imgarch} \
  --build-arg NODE_VERSION=${NODE_VERSION} \
  --build-arg buildarch=${buildarch} \
  --build-arg BUILDER_IMG=${BUILDER_IMG}

if [ "${CI_COMMIT_BRANCH}" = "master" ]; then
  docker.manifest ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH} latest
  docker.manifest ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH} ${MAGICMIRROR_VERSION}
  docker.sync "${CI_REGISTRY_IMAGE}:latest ${CI_REGISTRY_IMAGE}:${MAGICMIRROR_VERSION}"
else
  docker.manifest ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH} ${CI_COMMIT_BRANCH}
  docker.sync "${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}"
fi

# alpine image
if [ "${imgarch}" = "amd64" ]; then
  dest="--destination ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}_alpine"
  if [ "${CI_COMMIT_BRANCH}" = "master" ]; then
    dest="${dest} --destination ${CI_REGISTRY_IMAGE}:alpine"
  fi

  build --context ./build \
    --dockerfile Dockerfile-alpine \
    ${dest} \
    --build-arg NODE_VERSION=${NODE_VERSION} \
    --build-arg BUILDER_IMG=${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}_${imgarch}

  if [ "${CI_COMMIT_BRANCH}" = "master" ]; then
    docker.sync "${CI_REGISTRY_IMAGE}:alpine"
  else
    docker.sync "${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}_alpine"
  fi
fi
