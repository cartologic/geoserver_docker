FROM tomcat:9.0.4-jre8
LABEL "MAINTAINER"="Cartologic Development Team"
VOLUME /usr/local/tomcat/webapps
VOLUME /usr/local/tomcat/conf/api/classes
VOLUME /usr/local/tomcat/conf/Catalina/localhost
