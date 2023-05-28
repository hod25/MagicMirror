---
layout: single
title: Docker Images
permalink: /images/
toc: false
---

## Images on [Docker Hub](https://hub.docker.com/r/karsten13/magicmirror/):  [![](https://img.shields.io/docker/pulls/karsten13/magicmirror.svg)](https://hub.docker.com/r/karsten13/magicmirror/)

> ⚠️ Beginning with MagicMirror² version `v2.22.0` all images are based on debian bullseye, before this release the `linux/arm` images were based on debian buster. So if you are still running debian buster on your raspberry pi the `karsten13/magicmirror:v2.22.0` and `karsten13/magicmirror:latest` images won't work anymore, you have to switch to the compatible image `karsten13/magicmirror:buster`.

The docker image `karsten13/magicmirror` is available with these tags:

TAG                | OS/ARCH     | ELECTRON | DISTRO | DESCRIPTION
------------------ | ----------- | -------- | -------|------------------------------------------
**latest** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}) | linux/amd64 | no       | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} slim | only `serveronly`-mode
**latest** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}) | linux/arm   | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} slim | for raspberry pi
**latest** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}) | linux/arm64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} slim | for raspberry pi4 64-Bit-Version
**fat** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}_fat)| linux/amd64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} | both modes
**fat** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}_fat)| linux/arm   | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} | for raspberry pi
**fat** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}_fat)| linux/arm64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} | for raspberry pi4 64-Bit-Version
**buster** | linux/arm   | yes      | debian buster slim | for raspberry pi (deprecated)
**buster_fat** | linux/arm   | yes      | debian buster | for raspberry pi (deprecated)
**alpine**             | all 3 archs | no       | alpine | only `serveronly`-mode, smaller in size

Version {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }} is the current release of MagicMirror. Older version tags remain on docker hub, the other tags are floating tags and therefore overwritten with every new build. The used Node version is {{ site.data.gitlab.variables.NODE_VERSION_MASTER }}.

> The difference between `latest` and `fat` is image size and installed debian packages. For most use cases the `latest` image is sufficient. Some modules need dependencies which are not includes in `latest`, e.g. `python` or compilers, so in such cases you should use `fat`.

⛔ The following experimental images are not for production use:

TAG                | OS/ARCH     | ELECTRON | DISTRO | DESCRIPTION
------------------ | ----------- | -------- | -------|------------------------------------------
**develop**        | linux/amd64 | no       | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} slim | only `serveronly`-mode
**develop**        | linux/arm   | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} slim | for raspberry pi
**develop**        | linux/arm64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} slim | for raspberry pi4 64-Bit-Version
**develop_fat**    | linux/amd64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} | both modes
**develop_fat**    | linux/arm   | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} | for raspberry pi
**develop_fat**    | linux/arm64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION }} | for raspberry pi4 64-Bit-Version
**develop_buster** | linux/arm   | yes      | debian buster slim | for raspberry pi (deprecated)
**develop_buster_fat** | linux/arm   | yes      | debian buster | for raspberry pi (deprecated)
**develop_alpine** | all 3 archs | no       | alpine | only `serveronly`-mode, smaller in size

These images are using the `develop` branch of the MagicMirror git repository and Node version {{ site.data.gitlab.variables.NODE_VERSION_DEVELOP }}.
