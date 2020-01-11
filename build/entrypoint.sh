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

if [ "$StartEnv" = "test" ]; then 

  echo "start tests"
  Xvfb :99 -screen 0 1024x768x16 &
  export DISPLAY=:99
  grunt
  npm run test:unit
  npm run test:e2e

elif [ "$StartEnv" = "slim" ]; then 
  
  echo "start slim entrypoint"
  rm -rf /opt/magic_mirror/magicmirror/ && cd /opt/magic_mirror && git clone https://gitlab.com/khassel/magicmirror.git

  su -c "cd /opt/magic_mirror/modules/default && npm install || true" - node

  if [ "$BuildEnv" = "rpi" ]; then
    su -c "cd /opt/magic_mirror && npm start || true" - node
    su -c "arp-scan localhost || true" - node
  fi

  su -c "cd /opt/magic_mirror && node serveronly" - node
else

  echo "start magicmirror"
  su - node

  cd /opt/magic_mirror

  exec $1 $2
fi
