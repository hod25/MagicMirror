#!/bin/sh

mkdir -p /opt/magic_mirror/modules
mkdir -p /opt/magic_mirror/config

if [ ! -f /opt/magic_mirror/modules/default/defaultmodules.js ]; then
  cp -rn /opt/magic_mirror/mount_ori/modules/. /opt/magic_mirror/modules
fi

if [ ! -f /opt/magic_mirror/config/config.js ]; then
  cp -rn /opt/magic_mirror/mount_ori/config/. /opt/magic_mirror/config
fi

sudo chown -R node:node /opt/magic_mirror/modules
sudo chown -R node:node /opt/magic_mirror/config

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

  echo git clone
  git clone https://gitlab.com/khassel/magicmirror.git

  echo npm install
  cd /opt/magic_mirror/vendor
  npm install || true

  cd /opt/magic_mirror

  if [ "$BuildEnv" = "rpi" ]; then
    echo arp-scan
    sudo arp-scan localhost &
    echo npm start
    npm start &

  else

    echo node serveronly
    node serveronly &
  fi

  sudo chown -R node:node /home/node
  sudo chown -R node:node /opt/magic_mirror
  
else

  echo "start magicmirror"

  exec $1 $2
fi
