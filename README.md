![MagicMirror²: The open source modular smart mirror platform. ](https://github.com/MichMich/MagicMirror/raw/master/.github/header.png)

[![](https://david-dm.org/MichMich/MagicMirror.svg)](https://david-dm.org/MichMich/MagicMirror) [![](https://david-dm.org/MichMich/MagicMirror/dev-status.svg)](https://david-dm.org/MichMich/MagicMirror#info=devDependencies) [![](https://bestpractices.coreinfrastructure.org/projects/347/badge)](https://bestpractices.coreinfrastructure.org/projects/347) [![](https://img.shields.io/badge/license-MIT-blue.svg)](http://choosealicense.com/licenses/mit) [![](https://travis-ci.org/MichMich/MagicMirror.svg)](https://travis-ci.org/MichMich/MagicMirror) [![](https://snyk.io/test/github/MichMich/MagicMirror/badge.svg)](https://snyk.io/test/github/MichMich/MagicMirror)

**MagicMirror²** is an open source modular smart mirror platform. With a growing list of installable modules, the **MagicMirror²** allows you to convert your hallway or bathroom mirror into your personal assistant. **MagicMirror²** is built by the creator of [the original MagicMirror](http://michaelteeuw.nl/tagged/magicmirror) with the incredible help of a [growing community of contributors](https://github.com/MichMich/MagicMirror/graphs/contributors).

MagicMirror² focuses on a modular plugin system and uses [Electron](http://electron.atom.io/) as an application wrapper. So no more web server or browser installs necessary!

# Why Docker?
There are 2 usecases:
- Starting the application in server only mode by manually running `node serveronly`. This will start the server, after which you can open the application in your browser of choice. This is e.g useful for testing. Using docker simplifies this usecase by using the container instead of setting up the host with installing the node.js stuff etc.
- Using docker on the raspberry pi. The whole MagicMirror-stuff (including node.js, electron, ...) is already installed in the container, no need to install this stuff on your raspberry pi. Getting/Updating the container is done with one command ```docker pull karsten13/mm_hyp```.

# Run MagicMirror² in server only mode
You need a successful [Docker installation](https://docs.docker.com/engine/installation/) and docker-compose, which is not included in the docker linux installation. So if you are using linux you have to install it with:
```bash
sudo apt-get purge python-pip
curl https://bootstrap.pypa.io/get-pip.py | sudo python
sudo pip install docker-compose
```

Open a shell in the parent directory of MagicMirror and run 
```bash
git clone --depth 1 -b master https://github.com/khassel/docker-mm.git ~/docker-MagicMirror
```
This will create a new subdirectory docker-MagicMirror beside the MagicMirror directory.

Navigate to the docker-MagicMirror directory and open a shell in the subdirectory up-serveronly. Then execute

```bash
docker-compose up -d
```

The container will start and opening a browser with http://localhost:8080 should show the MagicMirror.

Executing
```bash
docker ps -a
```
will show all containers and 

```bash
docker-compose down
```

will stop and remove the MagicMirror container.

You may need to add your Docker Host IP to your `ipWhitelist` option. If you have some issues setting up this configuration, check [this forum post](https://forum.magicmirror.builders/topic/1326/ipwhitelist-howto).

```javascript
var config = {
	ipWhitelist: ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:172.17.0.1"]
};

if (typeof module !== "undefined") { module.exports = config; }
```

# Run MagicMirror² in on a raspberry pi

### Requirements
- raspberry pi version 2 or 3 with running raspian jessie
- LAN or WLAN access
- logged in as user pi (otherwise you have to substitute "pi" with your user in the following lines)

### Setup for MagicMirror
- create local directory: ```mkdir -p ~/magic_mirror/config``` and add your config.js file
- create local directory: ```mkdir -p ~/magic_mirror/modules``` and add your 3rd party modules

### Setup Docker
- get Docker: ```curl -sSL get.docker.com | sh```
- set Docker to auto-start: ```sudo systemctl enable docker```
- start the Docker daemon: ```sudo systemctl start docker``` (or reboot your pi)
- add user pi to docker group: ```sudo usermod -aG docker pi```

### Setup docker-compose
```bash
sudo apt-get purge python-pip
curl https://bootstrap.pypa.io/get-pip.py | sudo python
sudo pip install docker-compose
```

### Setup for graphical desktop
- install unclutter: ```sudo apt-get install -y unclutter```
- edit (here with nano) ```nano /home/pi/.config/lxsession/LXDE-pi/autostart``` and insert the following lines for disabling screensaver and mouse cursor:

    ```bash
    @xset s noblank
    @xset s off
    @xset -dpms
    @unclutter -idle 0.1 -pi
    ```
	
- uncomment the existing lines, otherwise you will see the pi desktop before MagicMirror has started
- edit (here with nano) ```nano ~/.bashrc``` and insert the following lines (otherwise docker has no access on the pi display):
    ```bash
    export DISPLAY=:0.0
    xhost +local:root
    ```
- execute ```sudo raspi-config``` and navigate to "3 boot options" and choose "B2 Wait for Network at Boot". If not set, some modules will remaining in "load"-state because MagicMirror starts to early.

### Setup docker-MagicMirror
```bash
git clone --depth 1 -b master https://github.com/khassel/docker-mm.git ~/docker-MagicMirror
```

### Get the docker image
```bash
docker pull karsten13/mm_hyp
```

### Starting MagicMirror
- goto ```cd ~/docker-MagicMirror/up-raspberry``` and execute ```docker-compose up -d```
- in case you want to stop it ```docker-compose down```

> The container is configured to restart automatically so after executing ```docker-compose up -d``` it will restart with every reboot of your pi.
