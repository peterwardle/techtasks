NAME := techtasks-housekeeping
TAG := $(if $(tag),$(tag),latest)
THIS := $(realpath $(lastword $(MAKEFILE_LIST)))
HERE := $(shell dirname "$(THIS)")

.PHONY: build
build:
	docker build --tag $(NAME):$(TAG) "$(HERE)"

.PHONY: run
run:
	docker-compose run --rm --entrypoint bash --workdir /opt/housekeeping app

.PHONY: test
test:
	docker-compose up -d
	docker-compose exec -T app /opt/housekeeping/bin/install.sh
	docker-compose exec -T app /opt/housekeeping/test.sh

.PHONY: clean
clean:
	docker-compose down --remove-orphans --volumes --rmi 'local'
	docker-compose rm -v --force
