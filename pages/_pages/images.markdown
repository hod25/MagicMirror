---
layout: single
title: Docker Images
permalink: /images/
toc: false
---

The docker image `karsten13/magicmirror` is provided in this versions:

TAG                | OS/ARCH     | ELECTRON | DESCRIPTION
------------------ | ----------- | -------- | -------------------------------------------------
latest (or v2.x.y) | linux/amd64 | no       | only `serveronly`-mode, based on debian buster
latest (or v2.x.y) | linux/arm   | yes      | for raspberry pi, based on debian buster
latest (or v2.x.y) | linux/arm64 | yes      | for raspberry pi4 64-Bit-Version, based on debian buster
alpine             | linux/amd64 | no       | only `serveronly`-mode, based on alpine, smaller in size

Version v2.x.y is the current release of MagicMirror. Older version tags remain on docker hub, the other tags are floating tags and therefore overwritten with every new build.

⛔ The following experimental images are not for production use:

TAG            | OS/ARCH     | ELECTRON | DESCRIPTION
-------------- | ----------- | -------- | --------------------------------------------------
develop        | linux/amd64 | no       | only `serveronly`-mode, based on debian buster
develop        | linux/arm   | yes      | for raspberry pi, based on debian buster
develop        | linux/arm64 | yes      | for raspberry pi4 64-Bit-Version, based on debian buster
develop_alpine | linux/amd64 | no       | only `serveronly`-mode, based on alpine, smaller in size

These images are using the `develop` branch of the MagicMirror git repository and a newer version of node.

