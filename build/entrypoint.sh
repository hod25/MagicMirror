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
  echo "installations for tests"

  apt-get install -y xvfb
  npm install -g grunt-cli
  Xvfb :99 -screen 0 1024x768x16 &
  su -c "cd /opt/magic_mirror && npm install" - node
  
  echo "start tests"
  su -c "export DISPLAY=:99" - node
  su -c "cd /opt/magic_mirror && grunt" - node
  su -c "cd /opt/magic_mirror && npm run test:unit" - node
  su -c "cd /opt/magic_mirror && npm run test:e2e" - node

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
