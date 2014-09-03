FROM centos:centos6

MAINTAINER Ronan Gill <ronan@gillsoft.org>

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD sshd.supervisor.conf /etc/supervisor/conf.d/
ADD authorized_keys /root/.ssh/authorized_keys
ADD sshd_config /etc/ssh/sshd_config

ENV HOME /root

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    yum update -y

# LOCALES
RUN yum reinstall -y glibc-common && \
    localedef -c -f UTF-8 -i en_GB en_GB.UTF-8 && \
    echo "LANG=\"en_GB.UTF-8\"" > /etc/sysconfig/i18n
    
ENV LANG en_GB.UTF-8

# SUPERVISOR
RUN yum install -y python-pip && \
    pip install pip --upgrade && \
    pip install supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

# SSH
RUN yum install -y openssh-server openssh-clients && \
    mkdir -p /var/run/sshd && \
    mkdir -p /root/.ssh && \
    chown root:root -R /root/.ssh && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys

EXPOSE 22

# TOOLs
RUN yum install -y curl wget vim-enhanced bash-completion tar unzip banner && \
    echo "alias ll='ls -h -l --color'" >> /etc/bashrc

RUN rm -rf /tmp/*

CMD COLUMNS=120 banner  $(hostname -I); \
    echo "$(hostname) : $(hostname -I)"; \
    supervisord -c /etc/supervisor/supervisord.conf
