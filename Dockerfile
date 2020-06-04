FROM debian:buster-slim
LABEL maintainer="Certificare C. Guychard<christophe@article714.org>"

# Container tooling

COPY container /container

ENV PATH=/usr/local/bin:${PATH}

# Build container

RUN /container/build.sh ${ANSIBLE_VERSION}

# Volumes

VOLUME [ "/container/config" ]
VOLUME [ "/container/logs" ]

# Set default user when running the container

USER ansible