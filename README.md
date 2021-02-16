# **MagicMirror²**

is an open source modular smart mirror platform. For more info visit the [project website](https://github.com/MichMich/MagicMirror). This project packs MagicMirror into a docker image.

# Why Docker?

Using docker simplifies the setup by using the container instead of setting up the host with installing all the node.js stuff etc.
Getting/Updating the container is done with one command.

We have two usecases:
- Scenario **server** ☝️: Running the application in server only mode. 
  
  This will start the server, after which you can open the application in your browser of choice. 
  This is e.g useful for testing or running the application somewhere online, so you can access it with a browser from everywhere. 
  
  
- Scenario **electron** ✌️: Using docker on the raspberry pi and starting the MagicMirror on the screen of the pi using electron.

# Docker Images

The docker image `karsten13/magicmirror` is provided in this versions:

TAG                | OS/ARCH     | ELECTRON | DESCRIPTION
------------------ | ----------- | -------- | -------------------------------------------------
latest (or v2.x.y) | linux/amd64 | no       | only `serveronly`-mode, based on debian buster
latest (or v2.x.y) | linux/arm   | yes      | for raspberry pi, based on debian buster
latest (or v2.x.y) | linux/arm64 | yes      | for raspberry pi4 64-Bit-Version, based on debian buster
alpine             | linux/amd64 | no       | only `serveronly`-mode, based on alpine, smaller in size

Version v2.x.y is the current release of MagicMirror. Older version tags remain on docker hub, the other tags are floating tags and therefore overwritten with every new build.

⛔ The following experimental images are not for production use:

TAG            | OS/ARCH     | ELECTRON | DESCRIPTION
-------------- | ----------- | -------- | --------------------------------------------------
develop        | linux/amd64 | no       | only `serveronly`-mode, based on debian buster
develop        | linux/arm   | yes      | for raspberry pi, based on debian buster
develop        | linux/arm64 | yes      | for raspberry pi4 64-Bit-Version, based on debian buster
develop_alpine | linux/amd64 | no       | only `serveronly`-mode, based on alpine, smaller in size

These images are using the `develop` branch of the MagicMirror git repository.

# Installation prerequisites for server only mode on a linux machine

* [Docker](https://docs.docker.com/engine/installation/)
* [docker-compose](https://docs.docker.com/compose/install/)

# Installation prerequisites for running on a raspberry pi

You can use [MagicMirrorOS](https://github.com/guysoft/MagicMirrorOS), it contains already all the following things needed (beside the hardware):

* running raspberry pi version >2 with running raspian with LAN or WLAN access
* [Docker](https://docs.docker.com/engine/installation/)
* [docker-compose](https://docs.docker.com/compose/install/)

> The pi image uses `debian:buster-slim` as base image. After upgrading from `stretch` to `buster` there is no longer a 
  simple solution to shutdown/restart the host from inside the container.
  As workaround you can use my [mmm-remote-docker module](https://gitlab.com/khassel/mmm-remote-docker).


# Installation prerequisites for running on a raspberry pi with Scenario **electron** ✌️

> 👉 if you use [MagicMirrorOS](https://github.com/guysoft/MagicMirrorOS) the steps in this section are already done.

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

Now cd into the new directory `magicmirror/run` and copy the yml-file depending on the scenario, for scenario **server** ☝️:
````bash
cd ./magicmirror/run
cp serveronly.yml docker-compose.yml
````

For scenario **electron** ✌️:
````bash
cd ./magicmirror/run
cp rpi.yml docker-compose.yml
````

# Start MagicMirror²

Navigate to `~/magicmirror/run` and execute

````bash
docker-compose up -d
````

The container will start and with scenario **electron** ✌️ the MagicMirror should appear on the screen of your pi. In server only mode opening a browser at http://localhost:8080 should show the MagicMirror (scenario **server** ☝️).

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

# Config, Modules, and custom CSS

After the first start of the container you find 3 directories
````bash
~/magicmirror/mounts/config
~/magicmirror/mounts/modules
~/magicmirror/mounts/css
````

`config` contains the `config.js`, you find more information [here](https://docs.magicmirror.builders/getting-started/configuration.html#general).
You can also use a `config.js.template` instead which can contain environment variables (this is not possible in `config.js`).
This make sense for keeping secrets (e.g. passwords, api keys) out of the config file. In `config.js.template` you can use shell variable syntax e.g. `${MY_SECRET}` as placeholder for your secrets. Don't forget to pass variables in `config.js.template` as environment variables to the container:
````
    environment:
      MY_SECRET: "abc"
````
> 👉 When the container starts, the `config.js` will be created using the `config.js.template`. An existing `config.js` will be overwritten and saved as `config.js-old`

For installing modules refer to the module website, the default modules are described [here](https://docs.magicmirror.builders/modules/introduction.html).

> There is one difference installing or updating modules compared to a standard setup: You must do the `git clone ...`, `git pull` and `npm install` commands from inside the running docker container. For this you execute `docker exec -it mm bash` and in this shell you navigate to the `modules/MMM-...` folder. For exiting from the container you type `exit`.

`css` contains the `custom.css` file, which you can use to override your
modules' appearance. CSS basics are documented
[here](https://forum.magicmirror.builders/topic/6808/css-101-getting-started-with-css-and-understanding-how-css-works), among many other places.

> 👉 The css-files in the `css` folder which exists in the MagicMirror git repo (currently only `main.css`) are overriden with the original file from inside the container with every restart. So if you need to change this file, you must stop this default copying by setting the environment variable `MM_OVERRIDE_CSS` to `false` in the `docker-compose.yml` file:
````
    environment:
      MM_OVERRIDE_CSS: "false"
````

# Default Modules

The default modules of MagicMirror are also located in the folder `~/magicmirror/mounts/modules`. These modules are maintained in the MagicMirror project and not - as other modules - in own git repositories. So if they are mounted the first time outside the container this version remains on the host and would never updated again. To prevent this, the docker container overrides the `default` modules folder with the versions from inside the container.

If someone does not agree with this procedure he can avoid the copy process by adding the environment variable `MM_OVERRIDE_DEFAULT_MODULES` to `false` in his `docker-compose.yml` file:
````
    environment:
      MM_OVERRIDE_DEFAULT_MODULES: "false"
````

# Timezone

The container tries to get the timezone by location. If this is not possible or wrong, you can set the timezone to a different value by editing the `docker-compose.yml` file. You have to add the timezone as environment variable:

````
    environment:
      TZ: Europe/Berlin
````

# Mouse cursor

The mouse cursor is diabled by default. You can enable it by adding the environment variable `MM_SHOW_CURSOR` to `true` in your `docker-compose.yml` file:
````
    environment:
      MM_SHOW_CURSOR: "true"
````

# More info's can be found in the [wiki](https://gitlab.com/khassel/magicmirror/-/wikis/home)
