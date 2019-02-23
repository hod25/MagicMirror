ARG myimage
FROM $myimage
MAINTAINER Karsten Hassel

EXPOSE 8080

WORKDIR /opt/magic_mirror

# myuser is "node" with id=1000
ENV myuser=node

# copy startscripts into container:
COPY entrypoint.sh slim-entrypoint.sh /tmp/

# arp-scan only needed for the module MMM-NetworkScanner, nano as editor
# npm install --unsafe-perm --> without param the mirror remains black!
ARG BuildEnv
RUN set -e; \
    if [ "$BuildEnv" = "rpi" ]; then \
      echo "creating user node ..."; \
      groupadd --gid 1000 $myuser; \
      useradd --uid 1000 --gid $myuser --create-home --home-dir /home/$myuser $myuser; \
    fi; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get -qy install git curl libgtk-3-0 libx11-xcb-dev libxtst6 libxss1 libgconf-2-4 libnss3-dev libasound2 systemd-sysv nano arp-scan; \
    apt-get clean; \
    chmod +x /tmp/*entrypoint.sh; \
    chown $myuser:$myuser /tmp/*entrypoint.sh; \
    chown -R $myuser:$myuser .; \
    if [ "$BuildEnv" = "rpi" ]; then \
      cd /root; \
      curl -sL https://deb.nodesource.com/setup_11.x -o nodesource_setup.sh; \
      bash nodesource_setup.sh; \
      rm nodesource_setup.sh; \
      apt-get -qy install nodejs; \
      apt-get clean; \
    fi;

USER $myuser

ARG MagicMirror_Version
RUN set -e; \
    node -v; \
    git clone --depth 1 -b $MagicMirror_Version --single-branch https://github.com/MichMich/MagicMirror.git .; \
    npm install --only=production; \
    npm cache clean -f; \
    cp config/config.js.sample config/config.js; \
    sed -i "s:address\: \"localhost\":address\: \"0.0.0.0\":" config/config.js; \
    sed -i "s:ipWhitelist\: \[.*\],:ipWhitelist\: \[\],:" config/config.js; \
    cp -R modules /opt/magic_mirror/unmount_modules; \
    cp -R config /opt/magic_mirror/unmount_config; \
    mv /tmp/*entrypoint.sh .;

USER root
