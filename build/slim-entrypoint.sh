#!/bin/sh

if [ ! -f /opt/magic_mirror/modules ]; then
  cp -Rn /opt/magic_mirror/unmount_modules/. /opt/magic_mirror/modules
  chown -R $myuser:$myuser /opt/magic_mirror/modules/
fi

if [ ! -f /opt/magic_mirror/config ]; then
  cp -Rn /opt/magic_mirror/unmount_config/. /opt/magic_mirror/config
  chown -R $myuser:$myuser /opt/magic_mirror/config/
fi

cd /opt/magic_mirror

git clone https://gitlab.com/khassel/magicmirror.git

node serveronly
