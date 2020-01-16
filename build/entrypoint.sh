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
  
  # adjust test timeouts
  sed -i "s:test.timeout(10000):test.timeout(30000):g" tests/e2e/global-setup.js
  cat tests/e2e/global-setup.js
  
  grunt
  npm run test:unit
  npm run test:e2e

elif [ "$StartEnv" = "slim" ]; then 
  
  echo "start slim entrypoint"

  rm -rf /opt/magic_mirror/magicmirror/ 
  cd /opt/magic_mirror 
  git clone https://gitlab.com/khassel/magicmirror.git
 
  cd /opt/magic_mirror/modules/default
  npm install || true

  cd /opt/magic_mirror

  if [ "$BuildEnv" = "rpi" ]; then
    npm start || true
    arp-scan localhost || true
  fi

  node serveronly

else

  echo "start magicmirror"

  exec $1 $2
fi
