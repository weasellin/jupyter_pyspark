FROM jupyter/scipy-notebook

MAINTAINER Ansel Lin <weasellin@gmail.com>

USER root

# Temporarily add jessie backports to get openjdk 8, but then remove that source
RUN echo 'deb http://cdn-fastly.deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list && \
    apt-get -y update && \
    apt-get install --no-install-recommends -t jessie-backports -y openjdk-8-jre-headless ca-certificates-java && \
    rm /etc/apt/sources.list.d/jessie-backports.list && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY install.sh /tmp/install.sh
COPY kernel.list /tmp/kernel.list
COPY kernel_template /tmp/kernel_template
COPY profile_script /tmp/profile_script
RUN cd /tmp && ./install.sh
RUN chown -R $NB_USER:users /home/$NB_USER/.ipython

USER $NB_USER
