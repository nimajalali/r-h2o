FROM harisekhon/h2o

# ENV R_BASE_VERSION 3.3.1

RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get update -y
RUN apt-get install -f
RUN apt-get install -y r-base-core r-base r-base-dev
RUN R -e 'install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-turing/7/R")))'
