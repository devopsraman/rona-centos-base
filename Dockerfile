FROM centos:centos6

MAINTAINER Ronan Gill <ronan@gillsoft.org>

ENV HOME /root

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum update -y

# LOCALES
RUN yum reinstall -y glibc-common
RUN localedef -c -f UTF-8 -i en_GB en_GB.UTF-8
RUN echo "LANG=\"en_GB.UTF-8\"" > /etc/sysconfig/i18n
ENV LANG en_GB.UTF-8

# SUPERVISOR
RUN yum install -y python-pip
RUN pip install pip --upgrade
RUN pip install supervisor
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/supervisor/conf.d
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD sshd.supervisor.conf /etc/supervisor/conf.d/

# SSH
RUN yum install -y openssh-server openssh-clients
RUN mkdir -p /var/run/sshd
RUN mkdir /root/.ssh
ADD authorized_keys /root/.ssh/authorized_keys
ADD sshd_config /etc/ssh/sshd_config
RUN chown root:root -R /root/.ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/authorized_keys

EXPOSE 22

# TOOLs
RUN yum install -y curl wget vim-enhanced bash-completion tar unzip banner
RUN echo "alias ll='ls -h -l --color'" >> /etc/bashrc

RUN rm -rf /tmp/*

CMD COLUMNS=120 banner  $(hostname -I); \
    supervisord -c /etc/supervisor/supervisord.conf
