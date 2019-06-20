#!/bin/sh

if [ ! -f /opt/magic_mirror/modules ]; then
  cp -Rn /opt/magic_mirror/unmount_modules/. /opt/magic_mirror/modules
  chown -R $myuser:$myuser /opt/magic_mirror/modules/
fi

if [ ! -f /opt/magic_mirror/config ]; then
  cp -Rn /opt/magic_mirror/unmount_config/. /opt/magic_mirror/config
  chown -R $myuser:$myuser /opt/magic_mirror/config/
fi

rm -rf /opt/magic_mirror/magicmirror/ && cd /opt/magic_mirror && git clone https://gitlab.com/khassel/magicmirror.git

su -c "cd /opt/magic_mirror/modules/default && npm install || true" - node

if [ "$BuildEnv"=="rpi" ]; then
  su -c "cd /opt/magic_mirror && npm start || true" - node
  su -c "arp-scan localhost || true" - node  
fi

su -c "cd /opt/magic_mirror && node serveronly" - node
