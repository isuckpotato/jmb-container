FROM alpine:3.22

LABEL maintainer="craumix <soeren@guertler.net>"

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="craumix/jmusicbot"
LABEL org.label-schema.description="Java based Discord music bot"
LABEL org.label-schema.url="https://github.com/jagrosh/MusicBot"
LABEL org.label-schema.vcs-url="https://github.com/craumix/jmb-container"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$VERSION
LABEL org.label-schema.docker.cmd="docker run -v ./config:/jmb/config -d craumix/jmusicbot"

USER root

RUN apk add --update --no-cache \
    openjdk11-jre-headless tini
    
RUN apk add --no-cache docker-ce

#No downloadable example config since 0.2.10
RUN mkdir -p /jmb/config
ADD --chmod=644 https://github.com/IsuckPOTATO/jmb-container/releases/download/0.4.3.9/JMusicBot-0.4.3.9.jar /jmb/JMusicBot.jar
ADD --chmod=644 https://github.com/jagrosh/MusicBot/releases/download/0.2.9/config.txt /jmb/config/config.txt
ADD --chmod=755 https://github.com/isuckpotato/jmb-container/releases/download/0.4.3.9/docker-entrypoint.sh /jmb/docker-entrypoint.sh


VOLUME /jmb/config

RUN addgroup -S appgroup -g 10001 && \
    adduser -S appuser -G appgroup -u 10000

USER appuser

WORKDIR /jmb/config

ENTRYPOINT ["/sbin/tini", "--", "/jmb/docker-entrypoint.sh"]
