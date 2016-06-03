FROM ubuntu:16.04
COPY ./provisioner.sh /tmp/provisioner.sh
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive /tmp/provisioner.sh \
  && rm -rf /var/lib/apt/lists/*
