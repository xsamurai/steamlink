# Running SteamLink in a docker container.

<br>
<br>
<br>

## Quick run


**1. Download the image**

`docker run  --net=host --device=/dev/input/ --volume="$HOME/.Xauthority:/root/.Xauthority:rw" --env="DISPLAY" xsamurai/steamlink:1.0.7`

<br> 
<br>


## Manually build the docker image


**1.**

`git clone https://github.com/xsamurai/steamlink.git`

<br>

**2.** `cd steamlink/docker && docker build -t steamlink:1.0.7`
