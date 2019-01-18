FROM debian:stretch

RUN dpkg --add-architecture armhf && \
    #getting gnupg2 to add repo keys below
    apt-get -y update && apt-get -y install gnupg2 zenity && \
    echo deb http://archive.raspberrypi.org/debian/ stretch main ui >> /etc/apt/sources.list && \
    apt-key adv --fetch-keys http://archive.raspberrypi.org/debian/raspberrypi.gpg.key  && \
    #errors out if zenity is added to the list below
    apt-get -y update && \
    apt-get -y install \
        libraspberrypi0 \
        libraspberrypi-dev  \
        libraspberrypi-doc  \
        libraspberrypi-bin  \
        qemu \
        curl \
        sudo \
        python \
        xterm \
        build-essential \
        net-tools \
        libqt5svg5:armhf \
        libusb-1.0-0:armhf \
        libsdl2-2.0-0:armhf \
        libsdl2-image-2.0-0:armhf \
        libsdl2-mixer-2.0-0:armhf \
        libsdl2-ttf-2.0-0:armhf && \
    for x in $(ls /opt/vc/lib/); do ln -s /opt/vc/lib/$x /lib/$x; done  && \
    curl http://media.steampowered.com/steamlink/rpi/steamlink_1.0.7.tar.xz -o steamlink_1.0.7.tar.xz && \
    tar -xvf steamlink_1.0.7.tar.xz && \
    cd launcher && make install && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* 

#binary paths updated to run with qemu-arm 
COPY files/steamlink.sh /opt/steamlink.sh
#Root check removed
COPY files/steamlink /usr/bin/steamlink

#initial failed run
RUN mkdir -p /root/.local/share/SteamLink && \
    echo '' > /root/.local/share/SteamLink/.ignore_cpuinfo 

CMD ["/usr/bin/steamlink"]
