**MagicMirror²** is an open source modular smart mirror platform. For more info visit the [project website](https://github.com/MichMich/MagicMirror).

# Why Docker?

Using docker simplifies the setup by using the container instead of setting up the host with installing all the node.js stuff etc.
Getting/Updating the container is done with one command.

There are 2 usecases:
- Running the application in server only mode. 
  
  This will start the server, after which you can open the application in your browser of choice. 
  This is e.g useful for testing or running the application somewhere online, so you can access it with a browser from everywhere. 
  
  
- Using docker on the raspberry pi. 

# Installation prerequisites for server only mode (not running on raspberry pi)

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

### Setup for graphical desktop
- install unclutter: `sudo apt-get install -y unclutter`
- edit (here with nano) `nano /home/pi/.config/lxsession/LXDE-pi/autostart` and insert the following lines for disabling screensaver and mouse cursor:
> Hint: With Debian Stretch 9 you must edit `sudo nano /etc/xdg/lxsession/LXDE-pi/autostart`.

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


# Installation of this Repository

Open a shell in your home directory and run
````bash
git clone https://gitlab.com/khassel/magicmirror.git
````

Now cd into the new directory `magicmirror` and execute the following line, whereas you have to substitute `<<mode>>` with `debian` if installing for server-only mode or `rpi` if installing on a raspberry pi:
````bash
cd ./magicmirror
./prepare_env <<mode>>
````

# Start MagicMirror²

Navigate to `~/magicmirror/run` and execute

````bash
docker-compose up -d
````

The container will start and on the raspberry you should see the mirror on the desktop. In server-only mode opening a browser at http://localhost:8080 should show the MagicMirror.

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

# Volume Mounts

After the first start of the container you find 2 directories
````bash
~/magicmirror/mounts/config
~/magicmirror/mounts/modules
````

In `config` you find the `config.js` and in `modules` all installed modules. You can change your config and add modules, for more information on that please visit the [project website](https://github.com/MichMich/MagicMirror).

# Using slim-images (beta feature)

[docker-slim](https://github.com/docker-slim/docker-slim) is a tool to minify your docker images.
If you want to use the slim-images (built with docker-slim) instead of the normal images, you
only need to change the `prepare_env` command from `./prepare_env debian` to `./prepare_env debian slim` and 
`./prepare_env rpi` to `./prepare_env rpi slim` respectively.

> This is a beta feature, so may the slim-image does not work as expected ...

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

