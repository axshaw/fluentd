FROM ubuntu:14.04
MAINTAINER Alex Shaw alex@ctmlabs.io

# install curl and fluentd deps
RUN apt-get update \
    && apt-get install -y curl libcurl4-openssl-dev ruby ruby-dev make

# install fluentd with plugins
RUN gem install fluentd --no-ri --no-rdoc \
    && fluent-gem install fluent-plugin-elasticsearch \
    fluent-plugin-record-modifier fluent-plugin-exclude-filter \
    && mkdir /etc/fluentd/

# install docker-gen
RUN cd /usr/local/bin \
    && curl -L https://github.com/jwilder/docker-gen/releases/download/0.4.0/docker-gen-linux-amd64-0.4.0.tar.gz \
    | tar -xzv

# add startup scripts and config files
ADD ./bin    /app/bin
ADD ./config /app/config

WORKDIR /app

ENV ES_HOST log.aws.simpl.es
ENV ES_PORT 5141
ENV LOG_ENV production
ENV DOCKER_HOST unix:///tmp/docker.sock

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/app/bin/start" ]
