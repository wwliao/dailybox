FROM debian:stretch
LABEL maintainer="liang-bo.wang@wustl.edu"

ARG DEBIAN_FRONTEND=noninteractive

# Upgrade APT
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure locale and timezone
RUN echo "US/Central" > /etc/timezone && \
    rm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata; \
    apt-get update && apt-get install -y locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure -f noninteractive locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8"

RUN apt-get update && apt-get install -y --no-install-recommends \
    tmux less libreadline7 gzip bzip2 gnupg2 \
    openssh-client wget curl ca-certificates rsync \
    libglib2.0-0 libxext6 libsm6 libxrender1 git vim-nox make htop \
    libnss-sss && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Fish shell
RUN wget -nv http://download.opensuse.org/repositories/shells:fish:release:2/Debian_9.0/Release.key -O Release.key && \
    apt-key add Release.key && \
    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_9.0/ /' > /etc/apt/sources.list.d/fish.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends fish && \
    chsh -s /usr/bin/fish && \
    rm Release.key && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Miniconda3
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86_64.sh -O $HOME/miniconda.sh && \
    /bin/bash $HOME/miniconda.sh -b -p /opt/conda && \
    rm $HOME/miniconda.sh

ENV PATH "/opt/conda/bin:${PATH}"

RUN conda config --add channels conda-forge && \
    conda config --add channels bioconda

# Fish shell setting
RUN git clone https://github.com/ccwang002/dotfiles.git $HOME/dotfiles && \
    cd $HOME/dotfiles && \
    /opt/conda/bin/python3 ./dotfile_setup.py --only "~/.inputrc" --only "~/.editrc" --only "*omf/" && \
    cd $HOME && curl -L https://get.oh-my.fish > install && \
    fish ./install --noninteractive -y && \
    rm ./install

# Vim setting
# RUN git clone --recursive https://github.com/ccwang002/dotvim.git $HOME/.vim

# Ripgrep
RUN wget --quiet https://github.com/BurntSushi/ripgrep/releases/download/0.5.2/ripgrep-0.5.2-x86_64-unknown-linux-musl.tar.gz -O $HOME/ripgrep.tar.gz && \
    cd $HOME && tar xf $HOME/ripgrep.tar.gz && \
    cd `find $HOME -type d -name "ripgrep*"` && \
    mkdir -p /usr/local/share/man/man1 && cp rg.1 /usr/local/share/man/man1/ && \
    cp rg /usr/local/bin && \
    rm -rf $HOME/ripgrep*
