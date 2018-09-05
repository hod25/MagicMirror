ARG myimage
FROM $myimage
MAINTAINER Karsten Hassel

EXPOSE 8080

WORKDIR /opt/magic_mirror

# copy startscript into container:
COPY entrypoint.sh /tmp

# arp-scan only needed for the module MMM-NetworkScanner, nano as editor
# npm install --unsafe-perm --> without param the mirror remains black!
ARG MagicMirror_Version
RUN set -e; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get -qy install git curl dos2unix libgtk-3-0 libx11-xcb-dev libxtst6 libxss1 libgconf-2-4 libnss3-dev libasound2 nano arp-scan; \
    apt-get clean; \
    echo "install nodejs"; \
    curl -sL https://deb.nodesource.com/setup_9.x | bash -; \
    apt-get install -y nodejs; \
    node -v; \
    apt-get clean; \
    git clone --depth 1 -b $MagicMirror_Version --single-branch https://github.com/MichMich/MagicMirror.git .; \
    npm install --unsafe-perm; \
    cp config/config.js.sample config/config.js; \
    cp -R modules /opt/magic_mirror/unmount_modules; \
    cp -R config /opt/magic_mirror/unmount_config;\
    mv /tmp/entrypoint.sh .; \
    dos2unix entrypoint.sh; \
    chmod +x entrypoint.sh
