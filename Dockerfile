# Interactive Brokers' Trader Workstation (TWS) container with GUI
# displaying on the Docker host's X-server.
#
# This is based on alekna/ib-tws Interactive Brokers' Trader
# Workstation (TWS) docker container, which uses VNC to access the
# GUI. It is also based on https://tpaschalis.github.io/sandboxed-browser-with-docker
# for the Chromium sandbox from a container and sound problems (?) fix.
#

FROM debian:buster

# Timezone is also in docker-compose file.
ENV HOME /root
ENV TZ Europe/Amsterdam
ENV SHELL /bin/bash


# Install basic Desktop environment for ibtws.
RUN apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y procps sudo curl less vim-nox zip openbox tint2 pcmanfm xfce4-terminal; \
    apt-get clean

RUN sed -i "s#\smain\s*\$# main contrib non-free#" /etc/apt/sources.list

# A web browser is required IB TWS to e.g. display help.
#
# Configure browser in IB TWS settings, as follows:
#   /usr/bin/chromium
#
RUN apt-get update; \
    apt-get install -y chromium \
      chromium-l10n \
      fonts-liberation \
      fonts-roboto \
      hicolor-icon-theme \
      libcanberra-gtk-module \
      libexif-dev \
      libgl1-mesa-dri \
      libgl1-mesa-glx \
      libpango1.0-0 \
      libv4l-0 \
      fonts-symbola \
      --no-install-recommends; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /etc/chromium.d/; \
    apt-get clean

# Create a non-root account to run IB TWS with.
RUN useradd -ms /bin/bash --uid 1000 --gid 100 tws; \
    usermod -G audio,video tws; 

# RUN echo "tws ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER tws
WORKDIR /home/tws
ENV HOME /home/tws

RUN mkdir -p /home/tws/Downloads; \
    mkdir -p /home/tws/Desktop; \
    mkdir -p /home/tws/bin

COPY bin/start.sh /home/tws/bin/

# Retrieve and install IB TWS (and its embedded JRE).
# curl -sO https://download2.interactivebrokers.com/installers/tws/latest/tws-latest-linux-x64.sh; \
RUN cd /home/tws ; \
    curl -sO https://download2.interactivebrokers.com/installers/tws/stable/tws-stable-linux-x64.sh; \
    echo "/home/tws/Jts" | sh ./tws-stable-linux-x64.sh; \
    rm ./tws-stable-linux-x64.sh

# The DISPLAY variable is required to display ibtws on your desktop.
ENV PS1='$ '
ENV DISPLAY=":0"

# Start the installed Interactive Brokers TWS. Its GUI will display on
# the computer that is hosting the Docker container. Be sure to allow
# access to its X-server via the following command:
#   xhost +LOCAL:
#
#ENTRYPOINT ["Jts/tws"]
#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/home/tws/bin/start.sh"]
