FROM jetty:9.4.7-jre8-alpine
LABEL "MAINTAINER"="Cartologic Development Team"
USER root
ENV GEOSERVER_VERSION 2.12.x
ENV GEOSERVER_DATA_DIR /geoserver_data
RUN cd /tmp && \
    wget http://build.geonode.org/geoserver/latest/geoserver-${GEOSERVER_VERSION}.war \
    -O geoserver.war
RUN mv /tmp/geoserver.war /var/lib/jetty/webapps
RUN mkdir -p $GEOSERVER_DATA_DIR
RUN chmod -R 777 $GEOSERVER_DATA_DIR
VOLUME ${GEOSERVER_DATA_DIR}