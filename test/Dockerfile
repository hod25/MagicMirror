ARG myimage
FROM $myimage

USER root 

RUN apt-get update && apt-get install -y xvfb && npm install -g grunt-cli

USER node

WORKDIR /opt/magic_mirror

RUN npm install

ENV StartEnv=test
