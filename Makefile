DOCKER_IMG="$(SERVER_NAME)/server"
CONTAINER_NAME="$(SERVER_NAME)Server"
DB_CONTAINER_NAME="$(SERVER_NAME)Postgres"

LINK := $(DB_CONTAINER_NAME):postgres

CID := $(shell cat run 2>/dev/null)

ifndef $(HOST)
	HOST := 0.0.0.0
endif

ifndef $(ENV)
	ENV := production
endif

ifndef $(LOG)
	LOG := /dev/null
endif

EXISTING := $(shell docker ps -aq -f "name=$(CONTAINER_NAME)")
EXISTING_DB := $(shell docker ps -aq -f "name=$(DB_CONTAINER_NAME)")

build:
	docker build -t $(DOCKER_IMG) .
	docker pull postgres

run: build stop rm
	mkdir -p postgres-data
	mkdir -p persistent-storage
	mkdir -p server-logs
	docker run -d -v '$(shell pwd)/postgres-data:/var/lib/postgresql/data' --name $(DB_CONTAINER_NAME) -e POSTGRES_PASSWORD=" " postgres
	docker run -d -p '$(HOST):80:3000' -p '$(HOST):443:3001' -v '$(shell pwd)/server-logs:/usr/src/app/usage-logs' -v '$(shell pwd)/persistent-storage:/usr/src/app/data/persistent-storage' --link $(LINK) --name $(CONTAINER_NAME) -e NODE_ENV=$(ENV) "$(DOCKER_IMG)"
	docker logs -f "$(CONTAINER_NAME)"

stop:
	@if [ -n "$(EXISTING)" ]; then\
		(docker logs $(CONTAINER_NAME) >> $(LOG) 2>>$(LOG); docker stop $(EXISTING));\
	fi;
	@if [ -n "$(EXISTING_DB)" ]; then\
		docker stop $(EXISTING_DB);\
	fi

rm:
	@if [ -n "$(EXISTING)" ]; then\
		docker rm $(EXISTING);\
	fi
	@if [ -n "$(EXISTING_DB)" ]; then\
		docker rm $(EXISTING_DB);\
	fi

clean: stop rm

all: build
