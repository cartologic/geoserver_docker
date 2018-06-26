FROM tomcat:9.0.4-jre8
LABEL "MAINTAINER"="Cartologic Development Team"
ENV JAVA_HOME /usr/lib/jvm/default-java
ENV GEOSERVER_VERSION 2.12.x
ENV GEOSERVER_DATA_DIR /geoserver_data
RUN ln -s /usr/lib/jvm/java-8-openjdk-amd64 /usr/lib/jvm/default-java
RUN apt-get autoremove --purge -y openjdk-8-jre-headless && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true \
    | debconf-set-selections && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" \
    > /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && \
    apt-get install -y oracle-java8-installer oracle-java8-set-default && \
    ln -s --force /usr/lib/jvm/java-8-oracle /usr/lib/jvm/default-java

RUN cd /tmp && \
    wget http://build.cartoview.net/geoserver.war \
    -O geoserver.war
RUN mv /tmp/geoserver.war /usr/local/tomcat/webapps
RUN unzip -q /usr/local/tomcat/webapps/geoserver.war -d /usr/local/tomcat/webapps/geoserver
RUN cd /tmp && \
    wget https://build.geoserver.org/geoserver/2.12.x/ext-latest/geoserver-2.12-SNAPSHOT-charts-plugin.zip \
    && unzip /tmp/geoserver-2.12-SNAPSHOT-charts-plugin.zip -d /tmp/charts_plugin \
    && cp /tmp/charts_plugin/* \
    /usr/local/tomcat/webapps/geoserver/WEB-INF/lib/ && rm -r /tmp/*
RUN mkdir -p $GEOSERVER_DATA_DIR
VOLUME ${GEOSERVER_DATA_DIR}
