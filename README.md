# Steam Link Linux Setup

This guide will help you setup Steam Link on your Debian OS or Debian VM which can run on Windows, MacOSX and other Linux Distros.


Follow the directions below or run the script 'setup_steamlink.sh'


## Step 1: Getting started as Root

Download and Install Debian Stretch and run the following steps:

```
1. dpkg --add-architecture armhf 

2. echo deb http://archive.raspberrypi.org/debian/ stretch main ui >> /etc/apt/sources.list

3. wget http://archive.raspberrypi.org/debian/raspberrypi.gpg.key -O - | apt-key add -

4. apt-get update

5. apt-get install qemu \
        curl \
        sudo \
        build-essential \
        libusb-1.0-0:armhf \
        libsdl2-2.0-0:armhf \
        libsdl2-image-2.0-0:armhf \
        libsdl2-mixer-2.0-0:armhf \
        libsdl2-ttf-2.0-0:armhf \
        libqt5svg5:armhf \
        libraspberrypi0 \
        libraspberrypi-dev  \
        libraspberrypi-doc  \
        libraspberrypi-bin


#Optional, If you are building a vm, install the follwoing for vbox guest installations
5a. apt-get install module-assistant dkms 

#ldconfig was not working atm, so this is a quick fix at 2am
6. for x in $(ls /opt/vc/lib/); do ln -s /opt/vc/lib/$x /lib/$x; done 

7. wget http://media.steampowered.com/steamlink/rpi/steamlink_1.0.7.tar.xz

8. tar -xvf steamlink_1.0.7.tar.xz

9. cd launcher && make install

#replace USERNAME with your account
10. usermod -a -G sudo USERNAME
```


## Step 2: Running SteamLink as normal user

```
1. mkdir -p ~/.local/share/SteamLink/
1. touch ~/.local/share/SteamLink/.ignore_cpuinfo
2. /usr/bin/steamlink 
```
