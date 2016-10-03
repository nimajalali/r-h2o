## Start with the official rocker image (lightweight Debian)
FROM rocker/r-base:latest

# Install Java.
RUN \
  apt-get update && \
  apt-get install -y openjdk-7-jdk && \
  rm -rf /var/lib/apt/lists/*

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

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
