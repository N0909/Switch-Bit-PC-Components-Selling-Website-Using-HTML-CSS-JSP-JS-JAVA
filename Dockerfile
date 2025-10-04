# Step 1: Use official Tomcat image with Java 17
FROM tomcat:10.1-jdk17

# Step 2: Remove default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Step 3: Copy your WAR file into Tomcat webapps
COPY switchbit.war /usr/local/tomcat/webapps/ROOT.war

# Step 4: Expose Tomcat port
EXPOSE 8080

# Step 6: Start Tomcat
CMD ["catalina.sh", "run"]
