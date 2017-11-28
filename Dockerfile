FROM ubuntu:latest
MAINTAINER Shrek Is Love <github.com/ShrekIsLoveLife>

ENV DEBIAN_FRONTEND noninteractive

# built-in packages
RUN apt-get update
# RUN apt-get -y upgrade

RUN apt-get -y install python-software-properties software-properties-common
RUN add-apt-repository ppa:mozillateam/ppa
RUN apt-get update
# RUN apt-get update -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/mozillateam-ubuntu-ppa-xenial.list
# RUN apt-get -y upgrade

RUN apt-get install -y --no-install-recommends --allow-unauthenticated \
  curl \
  less \
  policykit-1 \
  supervisor \
  pwgen sudo vim-tiny \
  net-tools \
  lxde  \
  firefox-esr \
  nginx \
  wget \
  aria2 \
  git \
  openssl \
  python-pip python-dev build-essential \
  dbus-x11 x11-utils \
  libtasn1-3-bin \
  libglu1-mesa \
  xorg

RUN apt-get autoclean
RUN apt-get autoremove
RUN rm -rf /var/lib/apt/lists/*

# tini for subreap                                   
ENV TINI_VERSION v0.16.1
# ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD root_fs /

RUN rm /etc/vim/vimrc.tiny && ln -s /etc/vim/vimrc /etc/vim/vimrc.tiny

ADD https://dl.bintray.com/tigervnc/stable/ubuntu-16.04LTS/amd64/tigervncserver_1.8.0-1ubuntu1_amd64.deb /root/
RUN dpkg -i /root/tigervncserver_1.8.0-1ubuntu1_amd64.deb
RUN apt-get -f install
RUN rm /root/tigervncserver_1.8.0-1ubuntu1_amd64.deb

RUN pip install --upgrade pip
RUN pip install setuptools wheel numpy
RUN pip install -r /usr/lib/web/requirements.txt

RUN useradd --shell /bin/bash --user-group user

EXPOSE 80
WORKDIR /root
ENV HOME=/home/user \
	  SHELL=/bin/bash

ENTRYPOINT ["/startup.sh"]
