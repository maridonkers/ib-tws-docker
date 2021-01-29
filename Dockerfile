# Interactive Brokers' Trader Workstation (TWS) container with GUI
# displaying on the Docker host's X-server.
#
# This is based on alekna/ib-tws Interactive Brokers' Trader Workstation (TWS)
# docker container, which uses VNC to access the GUI.
#

FROM debian:buster

# Timezone is also in docker-compose file.
ENV HOME /root
ENV TZ Europe/Amsterdam
ENV SHELL /bin/bash

# Install basic Desktop environment for ibtws.
RUN apt-get update; \
    apt-get upgrade -y; \
        apt-get install -y procps sudo curl zip openbox tint2 pcmanfm xfce4-terminal; \
    apt-get clean

# A web browser is required IB TWS to e.g. display help.
RUN apt-get update; \
    apt-get install -y firefox-esr; \
    apt-get clean

# Create a non-root account to run IB TWS with.
RUN useradd -ms /bin/bash --uid 1000 --gid 100 tws
# RUN echo "tws ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER tws
WORKDIR /home/tws
ENV HOME /home/tws

# Retrieve and install IB TWS (and its embedded JRE).
RUN mkdir /home/tws/Desktop; \
    cd /home/tws ; \
    curl -sO https://download2.interactivebrokers.com/installers/tws/latest/tws-latest-linux-x64.sh; \
    echo "/home/tws/Jts" | sh ./tws-latest-linux-x64.sh; \
        rm ./tws-latest-linux-x64.sh

# The DISPLAY variable is required to display ibtws on your desktop.
ENV PS1='$ '
ENV DISPLAY=":0"

# Start the installed Interactive Brokers TWS. Its GUI will display on
# the computer that is hosting the Docker container. Be sure to allow
# access to its X-server via the following command:
#   xhost +LOCAL:
#
ENTRYPOINT ["Jts/tws"]
