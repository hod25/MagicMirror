---
layout: single
title: Docker Setup
permalink: /
toc: false
---

> ⚠️ Beginning with MagicMirror² version `v2.22.0` all images are based on debian bullseye, before this release the `linux/arm` images were based on debian buster. So if you are still running debian buster on your raspberry pi the `karsten13/magicmirror:v2.22.0` and `karsten13/magicmirror:latest` images won't work anymore, you have to switch to the compatible image `karsten13/magicmirror:buster`.

# MagicMirror²

is an open source modular smart mirror platform. For more info visit the [project website](https://github.com/MichMich/MagicMirror). This project packs MagicMirror into a docker image.

# Why Docker?

Using docker simplifies the setup by using the docker image instead of setting up the host with installing all the node.js stuff etc.
Getting/Updating the image is done with one command.

We have two usecases:
- Scenario **server** ☝️: Running the application in server only mode.

  This will start the server, after which you can open the application in your browser of choice.
  This is e.g useful for testing or running the application somewhere online, so you can access it with a browser from everywhere.

- Scenario **electron** ✌️: Using docker on the raspberry pi and starting the MagicMirror on the screen of the pi using electron.
