#!/bin/sh

if [ ! -f /opt/magic_mirror/modules/default/defaultmodules.js ]; then
  cp -rn /opt/magic_mirror/mount_ori/modules/. /opt/magic_mirror/modules
  chown -R node:node /opt/magic_mirror/modules/
fi

if [ ! -f /opt/magic_mirror/config/config.js ]; then
  cp -rn /opt/magic_mirror/mount_ori/config/. /opt/magic_mirror/config
  chown -R node:node /opt/magic_mirror/config/
fi

su - node

cd /opt/magic_mirror

exec $1 $2
