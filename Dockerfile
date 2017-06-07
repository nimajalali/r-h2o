FROM rocker/r-base

#
# Oracle Java 8 Dockerfile
#
# https://github.com/dockerfile/java
# https://github.com/dockerfile/java/tree/master/oracle-java8
#

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer


# Define working directory.
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install Python.
RUN \
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/*

RUN pip install numpy==1.12.1 && \
    pip install scipy==0.19.0  && \
    pip install appdirs==1.4.3 && \
    pip install audioread==2.1.4 && \
    pip install cycler==0.10.0 && \
    pip install Cython==0.25.2 && \
    pip install decorator==4.0.11 && \
    pip install ez-setup==0.9 && \
    pip install functools32==3.2.3.post2 && \
    pip install joblib==0.11 && \
    pip install librosa==0.5.1 && \
    pip install matplotlib==2.0.0 && \
    pip install packaging==16.8 && \
    pip install pyparsing==2.2.0 && \
    pip install python-dateutil==2.6.0 && \
    pip install pytz==2016.10 && \
    pip install resampy==0.1.5 && \
    pip install scikit-learn==0.18.1 && \
    pip install six==1.10.0 && \
    pip install subprocess32==3.2.7

ARG H2O_VERSION=3.10.4.1

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends wget unzip && \
    wget -t 100 --retry-connrefused http://h2o-release.s3.amazonaws.com/h2o/rel-ueno/1/h2o-${H2O_VERSION}.zip && \
    unzip h2o-${H2O_VERSION}.zip && \
    rm h2o-${H2O_VERSION}.zip && \
    ln -s h2o-${H2O_VERSION} h2o

RUN apt-get install -y libcurl4-gnutls-dev
RUN R -e 'pkgs <- c("methods","statmod","stats","graphics","RCurl","jsonlite","tools","utils");for (pkg in pkgs) {if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }}'
RUN R -e 'install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-ueno/1/R")))'

COPY ffmpeg /usr/bin/
COPY ffprobe /usr/bin/
RUN chmod 777 /usr/bin/ffprobe
RUN chmod 777 /usr/bin/ffmpeg
