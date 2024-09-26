# imagen base
FROM postgis/postgis:16-3.4

# copio los repo de MR para descargar rapidamente los paquetes
COPY conf/debian-bullseye.list /etc/apt/sources.list

# instalo paquetes extra necesarios para la ejecucion del proceso
RUN apt-get update && apt-get install -y \
gdal-bin python2 git vim curl wget bash-completion axel \
postgis zip locales locales-all \
openjdk-17-jre osmosis osmctools osmium-tool

#configuro locales para ejecucion de los sql en la misma codificacion
ENV LANG=es_AR.UTF-8
ENV LC_ALL=es_AR.UTF-8

# descargo java8
RUN axel -n 10 https://download.java.net/openjdk/jdk8u44/ri/openjdk-8u44-linux-x64.tar.gz

# configuro java8
RUN tar xvf openjdk-8u44-linux-x64.tar.gz

# descargo otp
RUN axel -n 10 https://repo1.maven.org/maven2/org/opentripplanner/otp/1.2.0/otp-1.2.0-shaded.jar

# limpieza

RUN rm openjdk-8u44-linux-x64.tar.gz

RUN rm -rf /var/lib/apt/lists/*


RUN axel -n 10 https://repo1.maven.org/maven2/org/opentripplanner/otp/2.6.0/otp-2.6.0-shaded.jar

RUN axel -n 10 https://repo1.maven.org/maven2/org/opentripplanner/otp/2.4.0/otp-2.4.0-shaded.jar


#-60.9382,-33.175,-60.4493,-32.7233