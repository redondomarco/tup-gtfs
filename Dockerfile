FROM postgis/postgis:16-3.4

COPY conf/debian-bullseye.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
gdal-bin python2 git vim curl wget bash-completion \
postgis zip locales locales-all

ENV LANG es_AR.UTF-8
ENV LC_ALL es_AR.UTF-8

RUN wget https://download.java.net/openjdk/jdk8u44/ri/openjdk-8u44-linux-x64.tar.gz

RUN tar xvf openjdk-8u44-linux-x64.tar.gz

RUN wget https://repo1.maven.org/maven2/org/opentripplanner/otp/1.2.0/otp-1.2.0-shaded.jar