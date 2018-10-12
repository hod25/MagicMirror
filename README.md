**MagicMirror²** is an open source modular smart mirror platform. For more info visit the [project website](https://github.com/MichMich/MagicMirror).

[![DockerHub Badge](https://dockeri.co/image/karsten13/magicmirror)](https://hub.docker.com/r/karsten13/magicmirror/)

# Why Docker? [![Build Status](https://travis-ci.org/khassel/docker-mm.svg?branch=master)](https://travis-ci.org/khassel/docker-mm)
There are 2 usecases:
- Starting the application in server only mode by manually running `node serveronly`. This will start the server, after which you can open the application in your browser of choice. This is e.g useful for testing. Using docker simplifies this usecase by using the container instead of setting up the host with installing the node.js stuff etc.
- Using docker on the raspberry pi. The whole MagicMirror-stuff (including node.js, electron, ...) is already installed in the container, no need to install this stuff on your raspberry pi. Getting/Updating the container is done with one command.

# Run MagicMirror² in server only mode
You need a successful [Docker installation](https://docs.docker.com/engine/installation/) and docker-compose, which is not included in the docker linux installation. So if you are using linux you have to install it with:
```bash
sudo apt-get purge python-pip
curl https://bootstrap.pypa.io/get-pip.py | sudo python
sudo pip install docker-compose
```

Open a shell in the parent directory of MagicMirror and run 
```bash
git clone --depth 1 -b master https://github.com/khassel/docker-mm.git
cd ./docker-mm
./prepare_env debian
```
This will create a new subdirectory docker-mm beside the MagicMirror directory.

Navigate to the docker-mm directory and open a shell in the subdirectory run. Then execute

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

# Run MagicMirror² on a raspberry pi

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
git clone --depth 1 -b master https://github.com/khassel/docker-mm.git
cd ./docker-mm
./prepare_env rpi
```

### Starting MagicMirror
- goto ```cd ~/docker-mm/run``` and execute ```docker-compose up -d```
- in case you want to stop it ```docker-compose down```

> The container is configured to restart automatically so after executing ```docker-compose up -d``` it will restart with every reboot of your pi.

# Problems seeing the MagicMirror

If you have problmes to access your MagicMirror, check the params `address` and `ipWhitelist` in your 
`config.js`, check [this forum post](https://forum.magicmirror.builders/topic/1326/ipwhitelist-howto).

```javascript
var config = {
	address: "localhost", // Address to listen on, can be:
	                      // - "localhost", "127.0.0.1", "::1" to listen on loopback interface
	                      // - another specific IPv4/6 to listen on a specific interface
	                      // - "", "0.0.0.0", "::" to listen on any interface
	                      // Default, when address config is left out, is "localhost"
	port: 8080,
	ipWhitelist: ["127.0.0.1", "::ffff:127.0.0.1", "::1"], // Set [] to allow all IP addresses
	                                                       // or add a specific IPv4 of 192.168.1.5 :
	                                                       // ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.1.5"],
	                                                       // or IPv4 range of 192.168.3.0 --> 192.168.3.15 use CIDR format :
	                                                       // ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.3.0/28"],
```

