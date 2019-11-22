#!/bin/sh

mkdir -p /opt/magic_mirror/modules
mkdir -p /opt/magic_mirror/config

if [ ! -f /opt/magic_mirror/modules/default/defaultmodules.js ]; then
  cp -rn /opt/magic_mirror/mount_ori/modules/. /opt/magic_mirror/modules
  chown -R node:node /opt/magic_mirror/modules/
fi

if [ ! -f /opt/magic_mirror/config/config.js ]; then
  cp -rn /opt/magic_mirror/mount_ori/config/. /opt/magic_mirror/config
  chown -R node:node /opt/magic_mirror/config/
fi

rm -rf /opt/magic_mirror/magicmirror/ && cd /opt/magic_mirror && git clone https://gitlab.com/khassel/magicmirror.git

su -c "cd /opt/magic_mirror/modules/default && npm install || true" - node

if [ "$BuildEnv"=="rpi" ]; then
  su -c "cd /opt/magic_mirror && npm start || true" - node
  su -c "arp-scan localhost || true" - node
fi

su -c "cd /opt/magic_mirror && node serveronly" - node
