FROM jetty:9.4.7-jre8-alpine
USER root
ENV GEOSERVER_DATA_DIR /geoserver_data
RUN mkdir -p $GEOSERVER_DATA_DIR
RUN chown -R jetty:jetty $GEOSERVER_DATA_DIR
RUN chmod -R 777 $GEOSERVER_DATA_DIR
COPY geoserver.war /var/lib/jetty/webapps
VOLUME ${GEOSERVER_DATA_DIR}