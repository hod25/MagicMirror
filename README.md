**MagicMirror²** is an open source modular smart mirror platform. For more info visit the [project website](https://github.com/MichMich/MagicMirror).

# Why Docker?

Using docker simplifies the setup by using the container instead of setting up the host with installing all the node.js stuff etc.
Getting/Updating the container is done with one command.

There are 2 usecases:
- Scenario 1: Running the application in server only mode. 
  
  This will start the server, after which you can open the application in your browser of choice. 
  This is e.g useful for testing or running the application somewhere online, so you can access it with a browser from everywhere. 
  
  
- Scenario 2: Using docker on the raspberry pi and starting the magicmirror on the screen of the pi.

# Debian Buster

> This image uses `debian:buster-slim` as base image. After upgrading from `stretch` to `buster` there is no longer a simple solution to shutdown/restart the host from inside the container.
  As workaround you can use my [mmm-remote-docker module](https://gitlab.com/khassel/mmm-remote-docker).

# Installation prerequisites for server only mode with linux

You need a successful [Docker installation](https://docs.docker.com/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/), which is not included in the docker linux installation.

# Installation prerequisites for running on a raspberry pi

### Requirements
- raspberry pi version 2 or 3 with running raspian jessie
- LAN or WLAN access
- logged in as user pi (otherwise you have to substitute "pi" with your user in the following lines)

### Setup Docker
- get Docker: `curl -sSL get.docker.com | sh`
- set Docker to auto-start: `sudo systemctl enable docker`
- start the Docker daemon: `sudo systemctl start docker` (or reboot your pi)
- add user pi to docker group: `sudo usermod -aG docker pi` (you have to logout and login after this)

### Setup docker-compose
````bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py 
sudo python3 get-pip.py
sudo pip install docker-compose
````

# Installation prerequisites for running on a raspberry pi with Scenario 2

### Setup for graphical desktop
- install unclutter: `sudo apt-get install -y unclutter`
- edit (here with nano) `sudo nano /etc/xdg/lxsession/LXDE-pi/autostart` and insert the following lines for disabling screensaver and mouse cursor:
> Hint: With older debian versions you must edit this file instead `nano /home/pi/.config/lxsession/LXDE-pi/autostart`.

````bash
@xset s noblank
@xset s off
@xset -dpms
@unclutter -idle 0.1 -pi
@xhost +local:
````
	
- uncomment the existing lines, otherwise you will see the pi desktop before MagicMirror has started
- edit (here with nano) ```nano ~/.bashrc``` and insert the following line (otherwise docker has no access on the pi display):
````bash
xhost +local:
````
- execute `sudo raspi-config` and navigate to "3 boot options" and choose "B2 Wait for Network at Boot". If not set, some modules will remaining in "load"-state because MagicMirror starts to early.

> Before next installation steps please reboot your pi 

# Installation of this Repository

Open a shell in your home directory and run
````bash
git clone https://gitlab.com/khassel/magicmirror.git
````

Now cd into the new directory `magicmirror/run` and copy the yml-file depending on the scenario, for scenario 1:
````bash
cd ./magicmirror/run
cp serveronly.yml docker-compose.yml
````

For scenario 2:
````bash
cd ./magicmirror/run
cp rpi.yml docker-compose.yml
````

# Start MagicMirror²

Navigate to `~/magicmirror/run` and execute

````bash
docker-compose up -d
````

The container will start and with scenario 2 the magicmirror should appear on the screen of your pi. In server only mode opening a browser at http://localhost:8080 should show the MagicMirror (scenario 1).

> The container is configured to restart automatically so after executing `docker-compose up -d` it will restart with every reboot of your pi.


You can see the logs with

````bash
docker logs mm
````

Executing
````bash
docker ps -a
````
will show all containers and 

````bash
docker-compose down
````

will stop and remove the MagicMirror container.

# Config and Modules

After the first start of the container you find 2 directories
````bash
~/magicmirror/mounts/config
~/magicmirror/mounts/modules
````

`config` conatins the `config.js`, you find more information [here](https://docs.magicmirror.builders/getting-started/configuration.html#general).

For installing modules refer to the module website, the default modules are described [here](https://docs.magicmirror.builders/modules/introduction.html).

> There is one difference installing or updating modules compared to a standard setup: You must do the `git clone ...`, `git pull` and `npm install` commands from inside the running docker container. For this you execute `docker exec -it mm bash` and in this shell you navigate to the `modules/MMM-...` folder. For exiting from the container you type `exit`.

# Default Modules

The default modules of MagicMirror are also located in the folder `~/magicmirror/mounts/modules`. These modules are maintained in the MagicMirror project and not - as other modules - in own git repositories. So if they are mounted the first time outside the container this version remains on the host and would never updated again. To prevent this, the docker container overrides the `default` modules folder with the versions from inside the container.

If someone does not agree with this procedure he can avoid the copy process by adding the environment variable `MM_OVERRIDE_DEFAULT_MODULES` to `false` in his `docker-compose.yml` file:
````
    environment:
      MM_OVERRIDE_DEFAULT_MODULES: "false"
````

# Mouse cursor

The mouse cursor is diabled by default. You can enable it by adding the environment variable `MM_SHOW_CURSOR` to `true` in your `docker-compose.yml` file:
````
    environment:
      MM_SHOW_CURSOR: "true"
````

# Problems seeing the MagicMirror

If you have problmes to access your MagicMirror, check the params `address` and `ipWhitelist` in your 
`config.js`, check [this forum post](https://forum.magicmirror.builders/topic/1326/ipwhitelist-howto).

````javascript
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
````

