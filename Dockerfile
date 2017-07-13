FROM debian:stretch
MAINTAINER Liang-Bo Wang "liang-bo.wang@wustl.edu"

# Update the package repository
RUN apt-get update; apt-get upgrade -y; apt-get install locales

# Configure timezone
RUN DEBIAN_FRONTEND=noninteractive \
    echo "US/Central" > /etc/timezone; \
    dpkg-reconfigure tzdata

# Configure locale
RUN DEBIAN_FRONTEND=noninteractive \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y --fix-missing; \
    apg-get install -y tmux; \
    apt-get install -y --no-install-recommends libnss-sss; \
    apt-get clean all
