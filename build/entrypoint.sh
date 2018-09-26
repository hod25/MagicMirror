#!/bin/sh

if [ ! -f /opt/magic_mirror/modules ]; then
    cp -Rn /opt/magic_mirror/unmount_modules/. /opt/magic_mirror/modules
fi

if [ ! -f /opt/magic_mirror/config ]; then
    cp -Rn /opt/magic_mirror/unmount_config/. /opt/magic_mirror/config
fi

if [ -n "$2" ]; then
    # $2 contains url-path to file magic_mirror.tar.gz
	# e.g. https://my-website.com/mm-stuff
	rm -rf /opt/magic_mirror/config/*
	rm -rf /opt/magic_mirror/modules/*
	cd /opt
	curl -O $2/magic_mirror.tar.gz
	tar -zxvf magic_mirror.tar.gz
fi

cd /opt/magic_mirror

$1