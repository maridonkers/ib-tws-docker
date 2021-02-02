# Brings up the Docker container, which automatically starts IB TWS.
# The attach can be used to connect to the command prompt in the
# container, where e.g. a Ctrl-c can be used to force a stop.
#
all: up 

up:
	xhost +LOCAL:
	docker-compose up -d

down:
	docker-compose down

ls:
	docker ps -a

# Get custom seccomp profile (the wget) for Chromium sound.
build:
	wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json -O ./chrome.json
	xhost +LOCAL:
	docker-compose up -d --build

attach:
	xhost +LOCAL:
	docker attach ib_tws_1
