FROM tomcat:8.5.32
LABEL "MAINTAINER"="Cartologic Development Team"
ENV JAVA_HOME /usr/lib/jvm/default-java
ENV GEOSERVER_DATA_DIR /geoserver_data
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
RUN apt-get -y update

#Install extra fonts to use with sld font markers
RUN apt-get install -y  fonts-cantarell lmodern ttf-aenigma ttf-georgewilliams ttf-bitstream-vera ttf-sjfonts tv-fonts \
    build-essential libapr1-dev libssl-dev default-jdk
#-------------Application Specific Stuff ----------------------------------------------------

ARG GS_VERSION=2.14.3
ARG GEONODE_GS_VERSION=2.14.x
ENV ENABLE_JSONP true
ENV MAX_FILTER_RULES 20
ENV OPTIMIZE_LINE_WIDTH false
ENV MARLIN_TAG=0_9_2
ENV MARLIN_VERSION=0.9.2
ENV GEOWEBCACHE_CACHE_DIR /geoserver_data/gwc
ENV GEOSERVER_OPTS "-Djava.awt.headless=true -server -Xms2G -Xmx4G -Xrs -XX:PerfDataSamplingInterval=500 \
    -Dorg.geotools.referencing.forceXY=true -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:+UseParallelGC -XX:NewRatio=2 \
    -XX:+CMSClassUnloadingEnabled"
#-XX:+UseConcMarkSweepGC use this rather than parallel GC?
ENV JAVA_OPTS "$JAVA_OPTS $GEOSERVER_OPTS"
ENV GDAL_DATA /usr/local/gdal_data
ENV LD_LIBRARY_PATH /usr/local/gdal_native_libs:/usr/local/apr/lib:/opt/libjpeg-turbo/lib64
ENV GEOSERVER_LOG_LOCATION /geoserver_data/logs/geoserver.log
ADD logs $GEOSERVER_DATA_DIR
ENV FOOTPRINTS_DATA_DIR /opt/footprints_dir
# Unset Java related ENVs since they may change with Oracle JDK
ENV JAVA_VERSION=
ENV JAVA_DEBIAN_VERSION=
# Set JAVA_HOME to /usr/lib/jvm/default-java and link it to OpenJDK installation
RUN ln -s /usr/lib/jvm/java-8-openjdk-amd64 /usr/lib/jvm/default-java
ENV JAVA_HOME /usr/lib/jvm/default-java
ARG ORACLE_JDK=true
ARG TOMCAT_EXTRAS=true
ARG COMMUNITY_MODULES=true
ARG JAI_IMAGEIO=true
WORKDIR /tmp/
ADD resources /tmp/resources
ADD create_dirs.sh /
ADD setup.sh /
RUN chmod +x /*.sh
RUN /create_dirs.sh
VOLUME ${GEOSERVER_DATA_DIR}
RUN /setup.sh
ADD controlflow.properties $GEOSERVER_DATA_DIR
ADD sqljdbc4-4.0.jar $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/

# Clean up APT when done.
RUN echo "Yes, do as I say!" | apt-get remove --force-yes sed
RUN echo "Yes, do as I say!" | apt-get remove --force-yes login
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  \
    && dpkg --remove --force-depends  wget unzip build-essential