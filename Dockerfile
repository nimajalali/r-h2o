FROM r-base

ARG JAVA_VERSION=7
ARG JAVA_RELEASE=JRE

ENV JAVA_HOME=/usr

RUN apt-get update && \
    pkg="openjdk-$JAVA_VERSION"; \
    if [ "$JAVA_RELEASE" = "JDK" ]; then \
        pkg="$pkg-jdk"; \
    else \
        pkg="$pkg-jre-headless"; \
    fi; \
    apt-get install -y --no-install-recommends "$pkg" && \
    apt-get clean

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
