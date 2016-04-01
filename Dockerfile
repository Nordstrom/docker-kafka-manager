FROM quay.io/nordstrom/java-jdk:8

ENV KAFKA_MANAGER_VERSION=1.3.0.7 \
    SCALA_VERSION=2.11.7 \
    SBT_VERSION=0.13.9

ADD kafka-manager-${KAFKA_MANAGER_VERSION} /opt/kafka-manager

ENTRYPOINT [ "/opt/kafka-manager/bin/kafka-manager" ]
