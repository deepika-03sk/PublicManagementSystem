FROM tomcat:10.1-jdk21-temurin-jammy

RUN rm -rf /usr/local/tomcat/webapps/*

COPY PublicManagementSystem.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080