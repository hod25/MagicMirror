#!/bin/sh

sudo rm -rf /opt/magic_mirror/modules/default

sudo mkdir -p /opt/magic_mirror/modules/default
sudo mkdir -p /opt/magic_mirror/config

sudo cp -r /opt/magic_mirror/mount_ori/modules/default/. /opt/magic_mirror/modules/default/

if [ ! -f /opt/magic_mirror/config/config.js ]; then
  sudo cp /opt/magic_mirror/mount_ori/config/config.js.sample /opt/magic_mirror/config/config.js
fi

sudo chown -R node:node /opt/magic_mirror/modules
sudo chown -R node:node /opt/magic_mirror/config

if [ "$MM_SHOW_CURSOR" = "true" ]; then 
  sed -i "s|  cursor: .*;|  cursor: auto;|" /opt/magic_mirror/css/main.css
fi

if [ "$StartEnv" = "test" ]; then 
  echo "start tests ..."
  Xvfb :99 -screen 0 1024x768x16 &
  export DISPLAY=:99
  
  # adjust test timeouts
  sed -i "s:test.timeout(10000):test.timeout(30000):g" tests/e2e/global-setup.js
  cat tests/e2e/global-setup.js
  
  if [ "${CI_COMMIT_REF_NAME}" = "master" ]; then
    grunt
  else
    npm run test:lint
  fi;
  npm run test:e2e
  npm run test:unit

else

  echo "start magicmirror"

  exec "$@"
fi
