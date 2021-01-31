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

build:
	xhost +LOCAL:
	docker-compose up -d --build

attach:
	xhost +LOCAL:
	docker attach ib_tws_1
