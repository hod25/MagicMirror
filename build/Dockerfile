ARG myimage
FROM $myimage
MAINTAINER Karsten Hassel

EXPOSE 8080

RUN apt-get update && apt-get upgrade -y

# arp-scan only needed for the module MMM-NetworkScanner, nano as editor:
RUN apt-get -qy install git curl dos2unix libgtk2.0-0 libx11-xcb-dev libxtst6 libxss1 libgconf-2-4 libnss3-dev libasound2 nano arp-scan

# node
RUN echo "install nodejs" && curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install -y nodejs

WORKDIR /opt/magic_mirror

ARG MagicMirror_Version
# getting MagicMirror from github
RUN git clone --depth 1 -b $MagicMirror_Version --single-branch https://github.com/MichMich/MagicMirror.git .

# install (without param the mirror remains black):
RUN npm install --unsafe-perm

# copy sample to real config:
RUN cp config/config.js.sample config/config.js

# create copies for unmount:
RUN cp -R modules /opt/magic_mirror/unmount_modules
RUN cp -R config /opt/magic_mirror/unmount_config

# copy startscript into container:
COPY docker-entrypoint.sh /opt/magic_mirror
RUN dos2unix docker-entrypoint.sh && chmod +x docker-entrypoint.sh
