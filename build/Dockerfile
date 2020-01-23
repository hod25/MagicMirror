ARG myimage
FROM $myimage
MAINTAINER Karsten Hassel

EXPOSE 8080

USER root

ENV ELECTRON_DISABLE_SANDBOX=1 \
    DEBIAN_FRONTEND=noninteractive

WORKDIR /opt/magic_mirror

# copy startscripts into container:
COPY entrypoint.sh /tmp/
COPY qemu-arm-static /usr/bin

# systemd-sysv, arp-scan and sudo needed for the module MMM-NetworkScanner
# sudo needed for the module MMM-Remote-Control
# sudo needed for cp in entrypoint
RUN set -e; \
    apt-get update; \
    apt-get upgrade -y --allow-unauthenticated; \
    apt-get -qy --allow-unauthenticated install git libgtk-3-0 libx11-xcb-dev libnss3-dev libxss1 libasound2 nano \
      systemd-sysv arp-scan sudo; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
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
ARG UseLatestDependencies
RUN set -e; \
    node -v; \
    git clone --depth 1 -b ${MagicMirror_Version} --single-branch https://github.com/MichMich/MagicMirror.git .; \
    if [ $UseLatestDependencies ]; then \
      sed -r -i "s|\"\^[0-9]+\.[0-9]+\.[0-9]+\"|\"latest\"|g" package.json; \
      sed -i "s|\"jsdom\": \".*\"|\"jsdom\": \"\^11\.12\.0\"|" package.json; \
    else \
      if [ -n "${Spectron_Version}" ]; then sed -i "s|\"spectron\": \".*\"|\"spectron\": \"${Spectron_Version}\"|" package.json; fi; \
      if [ -n "${Electron_Version}" ]; then sed -i "s|\"electron\": \".*\"|\"electron\": \"${Electron_Version}\"|" package.json; fi; \
    fi; \  
    cat package.json; \
    echo arch=$(arch); \
    if [ "$(arch)" = "armv7l" ]; then \
      echo "install rpi"; \
      npm install --only=production --arch=$(arch); \
    else \
      echo "install debian"; \
      npm install --only=production; \
    fi; \
    npm cache clean -f; \
    rm -rf /home/node/.cache; \
    cp config/config.js.sample config/config.js; \
    sed -i "s:address\: \"localhost\":address\: \"0.0.0.0\":" config/config.js; \
    sed -i "s:ipWhitelist\: \[.*\],:ipWhitelist\: \[\],:" config/config.js; \
    sed -i "s:xorg\=\$(pgrep Xorg):xorg=dummy:" run-start.sh; \
    mkdir mount_ori; \
    mv modules mount_ori/; \
    mv config mount_ori/; \
    mv /tmp/*entrypoint.sh .;

ENTRYPOINT ["./entrypoint.sh"]