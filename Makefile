KAFKA_MANAGER_VERSION=1.3.0.7
SBT_VERSION=0.13.9

.PHONY: build/container tag/container push/container

push/container: tag/container
	docker push quay.io/nordstrom/kafka-manager:$(KAFKA_MANAGER_VERSION)

tag/container: build/container
	docker tag kafka-manager quay.io/nordstrom/kafka-manager:$(KAFKA_MANAGER_VERSION)

build/container: build/docker/kafka-manager-$(KAFKA_MANAGER_VERSION) build/docker/Dockerfile
	cd build/docker; docker build -t kafka-manager .

build/docker/Dockerfile: Dockerfile
	cp $< $@

build/docker/kafka-manager-$(KAFKA_MANAGER_VERSION): build/docker/kafka-manager.zip | unzip
	cd build/docker; unzip $<

build/docker/kafka-manager.zip: build/kafka-manager-$(KAFKA_MANAGER_VERSION)/target/universal/kafka-manager-$(KAFKA_MANAGER_VERSION).zip | build/docker
	cp $< $@

build/kafka-manager-$(KAFKA_MANAGER_VERSION)/target/universal/kafka-manager-1.3.0.7.zip: build/kafka-manager-$(KAFKA_MANAGER_VERSION)/build.sbt | build
	cd build/kafka-manager-$(KAFKA_MANAGER_VERSION); sbt clean dist

build/kafka-manager-$(KAFKA_MANAGER_VERSION)/build.sbt: build/kafka-manager-src-$(KAFKA_MANAGER_VERSION).tar.gz
	cd build; tar xvzf kafka-manager-src-$(KAFKA_MANAGER_VERSION).tar.gz

build/kafka-manager-src-$(KAFKA_MANAGER_VERSION).tar.gz: | build
	curl -sLo $@ https://github.com/yahoo/kafka-manager/archive/$(KAFKA_MANAGER_VERSION).tar.gz

build build/docker:
	mkdir -p $@

sbt: /usr/local/bin/sbt
	brew update
	brew install sbt

unzip: /usr/bin/unzip
	echo "Could not find unzip (checked /usr/bin/unzip)"
	exit 1
