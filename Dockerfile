FROM centos:centos6

MAINTAINER Ronan Gill <ronan@gillsoft.org>

ENV HOME /root

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    yum update -y && \
    yum reinstall -y glibc-common && \
    yum install -y curl wget vim-enhanced bash-completion tar unzip telnet && \
    echo "alias ll='ls -h -l --color'" >> /etc/profile && \
    localedef -c -f UTF-8 -i en_GB en_GB.UTF-8 && \
    echo "LANG=\"en_GB.UTF-8\"" > /etc/sysconfig/i18n && \
    rm -rf /tmp/*
    
ENV LANG en_GB.UTF-8

CMD /bin/bash

