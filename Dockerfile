FROM debian:stretch
MAINTAINER Liang-Bo Wang "liang-bo.wang@wustl.edu"

ARG DEBIAN_FRONTEND=noninteractive

# Upgrade APT
RUN apt-get update; apt-get install -y apt-utils; apt-get clean all

# Configure locale and timezone
RUN echo "US/Central" > /etc/timezone && \
    rm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata; \
    apt-get install -y locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure -f noninteractive locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8; \
    apt-get clean all

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8"

RUN apt-get update && apt-get install -y --no-install-recommends \
    tmux less libreadline7 wget curl gzip bzip2 gnupg2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 git \
    libnss-sss && \
    apt-get clean all

# Fish shell
RUN wget -nv http://download.opensuse.org/repositories/shells:fish:release:2/Debian_9.0/Release.key -O Release.key && \
    apt-key add Release.key && \
    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_9.0/ /' > /etc/apt/sources.list.d/fish.list && \
    apt-get update && \
    apt-get install -y fish && \
    rm Release.key && \
    apt-get clean all

# Miniconda3
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.14-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH "/opt/conda/bin:${PATH}"
