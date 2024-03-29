# Brings up the Docker container, which automatically starts IB TWS.
# The attach can be used to connect to the command prompt in the
# container, where e.g. a Ctrl-c can be used to force a stop.
#
all: up 

up:
	xhost +LOCAL:
	docker-compose up

down:
	sync
	docker-compose down

# If problems persist after a force-down then manually restart Docker daemon.
force-down:
	sync
	docker rm -f ib_tws_1

ls:
	docker ps -a

# Get custom seccomp profile (the wget) for browser sound.
rebuild:
	mkdir -p ./Jts
	mkdir -p ./data
	wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json -O ./chrome.json
	xhost +LOCAL:
	docker-compose build --no-cache

build:
	xhost +LOCAL:
	docker-compose build

attach:
	xhost +LOCAL:
	docker attach ib_tws_1

shell:
	xhost +LOCAL:
	docker exec -it ib_tws_1 /bin/bash
