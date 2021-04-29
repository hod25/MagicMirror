---
layout: single
title: FAQ
permalink: /faq/
---

## MagicMirror is black without content

If you cannot access your MagicMirror (black screen), check the params `address` and `ipWhitelist` in your 
`config.js`, see [this forum post](https://forum.magicmirror.builders/topic/1326/ipwhitelist-howto).

You should try the following parameters if you have problems:

```javascript
var config = {
	address: "0.0.0.0",
	port: 8080,
	ipWhitelist: [],
  ...
```

## How to start MagicMirror without docker-compose?

If you don't want to use `docker-compose` yo can start and stop your container with `docker` commands. For starting the container you have to translate the `docker-compose.yml` file into a `docker run ...` command. Here an example:

`docker-compose.yml`:
```yaml
version: '3'

services:
  magicmirror:
    container_name: mm
    image: karsten13/magicmirror:latest
    ports:
      - "8080:8080"
    volumes:
      - ../mounts/config:/opt/magic_mirror/config
      - ../mounts/modules:/opt/magic_mirror/modules
      - ../mounts/css:/opt/magic_mirror/css
    restart: unless-stopped
    command: 
      - npm
      - run
      - server
```

Corresponding `docker run` command:

```yaml
docker run  -d \
    --publish 8080:8080 \
    --restart always \
    --volume ~/magicmirror/mounts/config:/opt/magic_mirror/config \
    --volume ~/magicmirror/mounts/modules:/opt/magic_mirror/modules \
    --volume ~/magicmirror/mounts/css:/opt/magic_mirror/css \
    --name mm \
    karsten13/magicmirror:latest npm run server
```

You can stop and remove the container with `docker rm -f mm`.

## How to patch a file of MagicMirror?

You may want to test something or fix a bug in MagicMirror and therefore you want to edit a file of the MagicMirror installation.
With a classic install this is no problem, just edit the file, save it and restart MagicMirror.

In a container setup this is not so simple. You can login into the container with `docker exec -it mm bash` and edit the file there.
This solution works as long as no restart of MagicMirror is required. After a restart your changes are gone ...

So how to handle this?

The short story: Copy the file from inside the container to a directory on the host. Add a volume mount to the `docker-compose.yml` which mounts the local file back into the container. Now you can edit the file on the host and the changes are provided to the container. No problem if you need to restart the container.

The long story with example: In MagicMirror v2.11.0 is a bug which stops the MMM-Remote-Control to work ([see](https://github.com/Jopyth/MMM-Remote-Control/issues/185#issuecomment-608600298)). So to solve this problem the file `js/socketclient.js` must be patched.

To get the file from the container to the host (the container must be running) goto `~/magicmirror/run` and execute `docker cp mm:/opt/magic_mirror/js/socketclient.js .`

Now the file `socketclient.js` is located under `~/magicmirror/run`, you can do a `ls -la` to control this.

You can now edit this file and do your changes.

For getting the changes back into the container you have to edit the `docker-compose.yml` and insert a new volume mount, in the following example this is the first line under `volumes:`:

```yaml
version: '3'

services:
  magicmirror:
    container_name: mm
    image: karsten13/magicmirror:latest
    ports:
      - "8080:8080"
    volumes:
      - ./socketclient.js:/opt/magic_mirror/js/socketclient.js
      - ../mounts/config:/opt/magic_mirror/config
      - ../mounts/modules:/opt/magic_mirror/modules
    ...
```

Thats it. If you need to restart the MagicMirror container just execute `docker-compose up -d`.
