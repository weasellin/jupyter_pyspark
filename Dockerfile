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

COPY install_spark_from_list.sh /tmp/install_spark_from_list.sh
COPY spark_version.list /tmp/spark_version.list
COPY kernel_template /tmp/kernel_template
RUN cd /tmp && ./install_spark_from_list.sh

USER $NB_USER
