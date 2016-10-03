FROM rocker/r-base

# Install Java
# https://github.com/William-Yeh/docker-java7/blob/master/Dockerfile
RUN \
  echo "===> add webupd8 repository..."  && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
  apt-get update && \
  apt-get install -y gnupg && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
  apt-get update  && \
  \
  echo "===> install Java"  && \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
  DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java7-installer oracle-java7-set-default  && \
  \
  echo "===> clean up..."  && \
  rm -rf /var/cache/oracle-jdk7-installer  && \
  apt-get clean  && \
  rm -rf /var/lib/apt/lists/*

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

ARG H2O_VERSION=3.10.0.3

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends wget unzip && \
    wget -t 100 --retry-connrefused http://download.h2o.ai/versions/h2o-${H2O_VERSION}.zip && \
    unzip h2o-${H2O_VERSION}.zip && \
    rm h2o-${H2O_VERSION}.zip && \
    ln -s h2o-${H2O_VERSION} h2o && \
    apt-get purge -y wget unzip && \
    apt-get autoremove -y && \
    apt-get clean

RUN R -e 'install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-turing/7/R")))'
