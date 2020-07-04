ARG buildarch
FROM ${buildarch}node:buster-slim
LABEL maintainer="Karsten Hassel"

EXPOSE 8080

USER root

ENV ELECTRON_DISABLE_SANDBOX=1 \
    MM_OVERRIDE_DEFAULT_MODULES=true \
    MM_OVERRIDE_CSS=true

WORKDIR /opt/magic_mirror

# copy startscripts into container:
COPY entrypoint.sh /tmp/

# procps, arp-scan and sudo needed for the module MMM-NetworkScanner
# sudo needed for the module MMM-Remote-Control
# sudo needed for cp in entrypoint
ARG buildarch
RUN set -e; \
    apt-get update; \
    apt-get upgrade -y --allow-unauthenticated; \
    _pck="git nano sudo gettext"; \
    [ -z "${buildarch}" ] || _pck="${_pck} libgtk-3-0 libx11-xcb-dev libnss3-dev libxss1 libasound2 procps arp-scan"; \
    DEBIAN_FRONTEND=noninteractive apt-get -qy --allow-unauthenticated install ${_pck}; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    usermod -a -G video node; \
    echo "node ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
    chmod +x /tmp/entrypoint.sh; \
    chown node:node /tmp/entrypoint.sh; \
    chown -R node:node /home/node/; \
    chown -R node:node .; \
    c_rehash;

USER node

# create css/custom.css file https://github.com/MichMich/MagicMirror/issues/1977
ARG BuildRef
ARG GitRepo
RUN set -e; \
    node -v; \
    echo BuildRef="${BuildRef}"; \
    echo GitRepo="${GitRepo}"; \
    git clone --depth 1 -b ${BuildRef} --single-branch ${GitRepo} .; \
    git log -1; \
    cat package.json; \
    npm install --only=production; \
    npm cache clean -f; \
    rm -rf /home/node/.cache; \
    sed -i "s:address\: \"localhost\":address\: \"0.0.0.0\":" config/config.js.sample; \
    sed -i "s:ipWhitelist\: \[.*\],:ipWhitelist\: \[\],:" config/config.js.sample; \
    mkdir mount_ori; \
    mv modules mount_ori/; \
    mv config mount_ori/; \
    mv css mount_ori/; \
    mv /tmp/*entrypoint.sh .; \
    find . -name "*.md" -delete;

ENTRYPOINT ["./entrypoint.sh"]