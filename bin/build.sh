#!/bin/sh

set -e

function finish {
  docker.logout
}
trap finish EXIT

branch=${1}
buildarch=${2}

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
if [ -n "${buildarch}" ]; then
  imgarch=arm
  /register
else
  imgarch=amd64
fi

docker.login

/kaniko/executor --context ./build \
  --dockerfile Dockerfile \
  --destination ${DOCKER_USER}/magicmirror:${branch}_${imgarch} \
  --build-arg buildarch=${buildarch} \
  --build-arg BuildRef=${BuildRef} \
  --build-arg GitRepo=${GitRepo}

if [ "${branch}" = "master" ]; then
  docker.manifest ${DOCKER_USER}/magicmirror:${branch} latest
  docker.manifest ${DOCKER_USER}/magicmirror:${branch} ${MagicMirror_Version}
  docker.readme magicmirror
else
  docker.manifest ${DOCKER_USER}/magicmirror:${branch} ${branch}
fi
