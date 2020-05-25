#!/bin/sh

default_dir="/opt/magic_mirror/modules/default"
config_dir="/opt/magic_mirror/config"

[ ! -d "${default_dir}" ] && MM_OVERRIDE_DEFAULT_MODULES=true

if [ "${MM_OVERRIDE_DEFAULT_MODULES}" = "true" ]; then 
  echo "copy default modules to host ..."
  sudo rm -rf ${default_dir}
  sudo mkdir -p ${default_dir}
  sudo cp -r /opt/magic_mirror/mount_ori/modules/default/. ${default_dir}/
fi

sudo mkdir -p ${config_dir}

if [ ! -f ${config_dir}/config.js ]; then
  echo "copy default config.js to host ..."
  sudo cp /opt/magic_mirror/mount_ori/config/config.js.sample ${config_dir}/config.js
fi

echo "chown modules and config folder ..."
sudo chown -R node:node /opt/magic_mirror/modules
sudo chown -R node:node ${config_dir}

if [ "$MM_SHOW_CURSOR" = "true" ]; then 
  echo "enable mouse cursor ..."
  sed -i "s|  cursor: .*;|  cursor: auto;|" /opt/magic_mirror/css/main.css
fi

if [ "$StartEnv" = "test" ]; then
  echo "start tests ..."
  set -e

  Xvfb :99 -screen 0 1024x768x16 &
  export DISPLAY=:99

  # adjust test timeouts
  sed -i "s:test.timeout(10000):test.timeout(30000):g" tests/e2e/global-setup.js
  cat tests/e2e/global-setup.js

  if [ "${CI_COMMIT_REF_NAME}" = "master" ]; then
    grunt
  else
    echo "/mount_ori/**/*" >> .prettierignore
    npm run test:prettier
    npm run test:js
    npm run test:css
  fi;
  npm run test:e2e
  npm run test:unit
else
  echo "start magicmirror"

  exec "$@"
fi
