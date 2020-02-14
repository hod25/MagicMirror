FROM node:buster-slim
MAINTAINER Karsten Hassel

EXPOSE 8080

USER root

ENV ELECTRON_DISABLE_SANDBOX=1

WORKDIR /opt/magic_mirror

# copy startscripts into container:
COPY entrypoint.sh /tmp/

# systemd-sysv, arp-scan and sudo needed for the module MMM-NetworkScanner
# sudo needed for the module MMM-Remote-Control
# sudo needed for cp in entrypoint
RUN set -e; \
    apt-get update; \
    apt-get upgrade -y --allow-unauthenticated; \
    DEBIAN_FRONTEND=noninteractive apt-get -qy --allow-unauthenticated install git libgtk-3-0 libx11-xcb-dev libnss3-dev libxss1 libasound2 nano \
      libatomic1 \
      procps arp-scan sudo; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    usermod -a -G video node; \
    echo "node ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
    chmod +x /tmp/entrypoint.sh; \
    chown node:node /tmp/entrypoint.sh; \
    chown -R node:node /home/node/; \
    chown -R node:node .;

USER node

ARG BuildRef
ARG MagicMirror_Version
RUN set -e; \
    node -v; \
    git clone --depth 1 -b ${MagicMirror_Version} --single-branch https://github.com/MichMich/MagicMirror.git .; \
    if [ ! "$BuildRef" = "_test" ]; then \
      # current electron version 3.x needs spectron 5.x to run tests:
      sed -i "s|\"spectron\": \".*\"|\"spectron\": \"\^5\.0\.0\"|" package.json; \
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
    sed -i "s:address\: \"localhost\":address\: \"0.0.0.0\":" config/config.js.sample; \
    sed -i "s:ipWhitelist\: \[.*\],:ipWhitelist\: \[\],:" config/config.js.sample; \
    [ -f run-start.sh ] && sed -i "s:xorg\=\$(pgrep Xorg):xorg=dummy:" run-start.sh; \
    mkdir mount_ori; \
    mv modules mount_ori/; \
    mv config mount_ori/; \
    mv /tmp/*entrypoint.sh .; \
    find . -name "*.md" -delete; 

ENTRYPOINT ["./entrypoint.sh"]