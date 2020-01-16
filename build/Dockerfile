ARG myimage
FROM $myimage
MAINTAINER Karsten Hassel

EXPOSE 8080

USER root

WORKDIR /opt/magic_mirror

# copy startscripts into container:
COPY entrypoint.sh /tmp/
COPY qemu-arm-static /usr/bin

# arp-scan and sudo only needed for the module MMM-NetworkScanner, nano as editor
RUN set -e; \
    apt-get update; \
    apt-get upgrade -y --allow-unauthenticated; \
    apt-get -qy --allow-unauthenticated install git curl libgtk-3-0 libx11-xcb-dev libxtst6 libxss1 libgconf-2-4 libnss3-dev libasound2 systemd-sysv nano arp-scan sudo; \
    apt-get clean; \
    usermod -a -G video node; \
    echo "node ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
    chmod +x /tmp/entrypoint.sh; \
    chown node:node /tmp/entrypoint.sh; \
    chown -R node:node /home/node/; \
    chown -R node:node .;

USER node

ARG MagicMirror_Version
ARG Spectron_Version
ARG Electron_Version
RUN set -e; \
    node -v; \
    git clone --depth 1 -b ${MagicMirror_Version} --single-branch https://github.com/MichMich/MagicMirror.git .; \
    if [ -n "${Spectron_Version}" ]; then sed -i "s|\"spectron\": \".*\"|\"spectron\": \"${Spectron_Version}\"|" package.json; fi; \
    if [ -n "${Electron_Version}" ]; then sed -i "s|\"electron\": \".*\"|\"electron\": \"${Electron_Version}\"|" package.json; fi; \
    cat package.json; \
    if [ "$(arch)" = "armv7l" ]; then \
      npm install --only=production --arch=$(arch); \
    else \
      npm install --only=production; \
    fi; \
    npm cache clean -f; \
    cp config/config.js.sample config/config.js; \
    sed -i "s:address\: \"localhost\":address\: \"0.0.0.0\":" config/config.js; \
    sed -i "s:ipWhitelist\: \[.*\],:ipWhitelist\: \[\],:" config/config.js; \
    sed -i "s:xorg\=\$(pgrep Xorg):xorg=dummy:" run-start.sh; \
    sed -i "s:electron js/electron.js \$1:electron js/electron.js \$1 --no-sandbox:" run-start.sh; \
    mkdir mount_ori; \
    mv modules mount_ori/; \
    mv config mount_ori/; \
    mv /tmp/*entrypoint.sh .;

ENTRYPOINT ["./entrypoint.sh"]