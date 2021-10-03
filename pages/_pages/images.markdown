---
layout: single
title: Docker Images
permalink: /images/
toc: false
---

## Images on Docker Hub:  [![](https://dockeri.co/image/karsten13/magicmirror)](https://hub.docker.com/r/karsten13/magicmirror/)

The docker image `karsten13/magicmirror` is provided in this versions:

TAG                | OS/ARCH     | ELECTRON | DESCRIPTION
------------------ | ----------- | -------- | -------------------------------------------------
latest (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}) | linux/amd64 | no       | only `serveronly`-mode, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }} slim
latest (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}) | linux/arm   | yes      | for raspberry pi, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }} slim
latest (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}) | linux/arm64 | yes      | for raspberry pi4 64-Bit-Version, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }} slim
fat (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}_fat)| linux/amd64 | no       | only `serveronly`-mode, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }}
fat (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}_fat)| linux/arm   | yes      | for raspberry pi, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }}
fat (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}_fat)| linux/arm64 | yes      | for raspberry pi4 64-Bit-Version, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }}
alpine             | linux/amd64 | no       | only `serveronly`-mode, based on alpine, smaller in size

Version {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }} is the current release of MagicMirror. Older version tags remain on docker hub, the other tags are floating tags and therefore overwritten with every new build. The used Node version is {{ site.data.gitlab.variables.NODE_VERSION_MASTER }}.

The difference between `latest` and `fat` is image size and installed debian packages. For most use cases the `latest` image is sufficient. Some modules need dependencies which are not includes in `latest`, e.g. `python` or compilers, so in such cases you should use `fat`.

⛔ The following experimental images are not for production use:

TAG            | OS/ARCH     | ELECTRON | DESCRIPTION
-------------- | ----------- | -------- | --------------------------------------------------
develop        | linux/amd64 | no       | only `serveronly`-mode, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }} slim
develop        | linux/arm   | yes      | for raspberry pi, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }} slim
develop        | linux/arm64 | yes      | for raspberry pi4 64-Bit-Version, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }} slim
develop_fat    | linux/amd64 | no       | only `serveronly`-mode, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }}
develop_fat    | linux/arm   | yes      | for raspberry pi, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }}
develop_fat    | linux/arm64 | yes      | for raspberry pi4 64-Bit-Version, based on debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }}
develop_alpine | linux/amd64 | no       | only `serveronly`-mode, based on alpine, smaller in size

These images are using the `develop` branch of the MagicMirror git repository and Node version {{ site.data.gitlab.variables.NODE_VERSION_DEVELOP }}.

