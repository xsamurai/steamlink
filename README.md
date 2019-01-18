# Steam Link running in a Virtual Machine or Docker container


https://store.steampowered.com/app/353380/Steam_Link/

<br>

## Docker container

Follow the instructions in the docker folder.


## Virtual Machine

I've created a Virtualbox appliance that is configured and setup with steamlink, all you need to do is follow the Quick Setup instructions.  If you would like to build your own VM or install directly onto your Debian based OS, follow the Manual Setup instructions.


<br>

## Quick Setup


**1. Download and setup VirtualBox on your system.**

   https://www.virtualbox.org/wiki/Downloads

<br>
   
   
**2. Download my VirtualBox OVA from:**

  https://mega.nz/#!AEVUWa7Y!P5iCWd720Z7rwRx5qY4lkmWL--TdK-W__VFaYWeaFXE
  
  SIZE: 1.1G
  MD5SUM: ced3d3db58409df5e4fefff417d6bcde
   
   *if the link is down, please send me a message and I will reupload it.*
   
  <br> 
   
   
**3. Import the appliance and enjoy.**

   https://docs.oracle.com/cd/E26217_01/E26796/html/qs-import-vm.html

<br>


## Manual Setup



> ### Step 1: Getting started as Root

Download and Install Debian Stretch with Xwindows and after that run the following steps:

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
<br>

> ### Step 2: Running SteamLink as normal user

```
1. mkdir -p ~/.local/share/SteamLink/
1. touch ~/.local/share/SteamLink/.ignore_cpuinfo
2. /usr/bin/steamlink 
```
