# STAGE 0: use base image from Docker Hub and upgrade the existing packages
FROM caronc/apprise:latest AS base

USER root
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y &&\
  rm -rf /var/lib/apt/lists/*

# STAGE 1: copy contents of the original base image to a new image so we don't have overlapping files in layers
FROM scratch
COPY --from=base / /
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

# from https://github.com/caronc/apprise-api/blob/master/Dockerfile:
VOLUME /config
WORKDIR /opt/apprise
CMD ["/opt/apprise/webapp/supervisord-startup"]
