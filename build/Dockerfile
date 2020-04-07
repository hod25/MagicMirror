FROM node:buster-slim
MAINTAINER Karsten Hassel

EXPOSE 8080

USER root

ENV ELECTRON_DISABLE_SANDBOX=1

WORKDIR /opt/magic_mirror

# copy startscripts into container:
COPY entrypoint.sh /tmp/

# procps, arp-scan and sudo needed for the module MMM-NetworkScanner
# sudo needed for the module MMM-Remote-Control
# sudo needed for cp in entrypoint
RUN set -e; \
    apt-get update; \
    apt-get upgrade -y --allow-unauthenticated; \
    DEBIAN_FRONTEND=noninteractive apt-get -qy --allow-unauthenticated install git libgtk-3-0 libx11-xcb-dev libnss3-dev libxss1 libasound2 nano \
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

# create css/custom.css file https://github.com/MichMich/MagicMirror/issues/1977
ARG BuildRef
ARG GitRepo
RUN set -e; \
    node -v; \
    git clone --depth 1 -b ${BuildRef} --single-branch ${GitRepo} .; \
    cat package.json; \
    npm install --only=production; \
    npm cache clean -f; \
    rm -rf /home/node/.cache; \
    sed -i "s:address\: \"localhost\":address\: \"0.0.0.0\":" config/config.js.sample; \
    sed -i "s:ipWhitelist\: \[.*\],:ipWhitelist\: \[\],:" config/config.js.sample; \
    touch css/custom.css; \
    mkdir mount_ori; \
    mv modules mount_ori/; \
    mv config mount_ori/; \
    mv /tmp/*entrypoint.sh .; \
    find . -name "*.md" -delete; 

ENTRYPOINT ["./entrypoint.sh"]