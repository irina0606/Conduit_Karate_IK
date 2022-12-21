FROM maven:3.8.6-openjdk-18
# https://hub.docker.com/_/maven

WORKDIR /usr/src/app

COPY pom.xml /usr/src/app
COPY ./src/test/java /usr/src/app/src/test/java