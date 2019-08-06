FROM java:openjdk-8-jre
MAINTAINER JEY

# The used ZooKeeper version can also be supplied like this with the build command like this:
# --build-arg BIN_VERSION=zookeeper-3.5.5
ARG BIN_VERSION=zookeeper-3.5.5

WORKDIR /usr/share/zookeeper

EXPOSE 2181 2888 3888

# Install and set everything up
RUN apt-get install -y wget tar
RUN \
   wget -q -N https://www.apache.org/dist/zookeeper/$BIN_VERSION/apache-${BIN_VERSION}.tar.gz \
&& tar --strip-components=1 -C /usr/share/zookeeper -xvf apache-${BIN_VERSION}.tar.gz \
&& rm apache-${BIN_VERSION}.tar.gz \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# default parameters for config file:
ENV tickTime=2000
ENV dataDir=/var/lib/zookeeper/
ENV dataLogDir=/var/log/zookeeper/
ENV clientPort=2181
ENV initLimit=5
ENV syncLimit=2

# add startup script
ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/usr/share/zookeeper/entrypoint.sh"]