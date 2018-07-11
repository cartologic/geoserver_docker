FROM tomcat:9.0.10-jre8-alpine
LABEL "MAINTAINER"="Cartologic Development Team"
ENV GEOSERVER_VERSION 2.12.x
ENV GEOSERVER_DATA_DIR /geoserver_data
RUN cd /tmp && \
    wget http://build.cartoview.net/geoserver.war \
    -O geoserver.war
RUN mv /tmp/geoserver.war $CATALINA_HOME/webapps
RUN mkdir $CATALINA_HOME/webapps/geoserver
RUN unzip -q $CATALINA_HOME/webapps/geoserver.war -d $CATALINA_HOME/webapps/geoserver
RUN cd /tmp && \
    wget https://build.geoserver.org/geoserver/2.12.x/ext-latest/geoserver-2.12-SNAPSHOT-charts-plugin.zip \
    && mkdir /tmp/charts_plugin &&unzip /tmp/geoserver-2.12-SNAPSHOT-charts-plugin.zip -d /tmp/charts_plugin \
    && cp /tmp/charts_plugin/* \
    $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/ && rm -r /tmp/*
RUN mkdir -p $GEOSERVER_DATA_DIR
VOLUME ${GEOSERVER_DATA_DIR}