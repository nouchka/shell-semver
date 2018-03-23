DOCKER_IMAGE=semver-increment
DOCKER_NAMESPACE=nouchka

.DEFAULT_GOAL := build

run:
	docker run $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE) sh -c "echo -M 1.2.3|/usr/bin/$(DOCKER_IMAGE)"
	docker run $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE) sh -c "echo -m 1.2.3|/usr/bin/$(DOCKER_IMAGE)"
	docker run $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE) sh -c "echo -p 1.2.3|/usr/bin/$(DOCKER_IMAGE)"

build:
	faas-cli build -f $(DOCKER_IMAGE).yml
	docker build -t $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE) .

invoke:
	echo "nouchka/symfony latest"|faas-cli invoke -f $(DOCKER_IMAGE).yml $(DOCKER_IMAGE)

rm:
	faas-cli remove -f $(DOCKER_IMAGE).yml
	docker rmi -f $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE)
	sleep 5

deploy:
	faas-cli deploy -f $(DOCKER_IMAGE).yml
	sleep 10

test: rm build deploy invoke

docker-test: build run
