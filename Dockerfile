# Step 1: Use an official Tomcat image with Java 17
FROM tomcat:10.1-jdk17

# Step 2: Remove default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Step 3: Copy your WAR file into Tomcat webapps as ROOT.war
COPY target/switchbit.war /usr/local/tomcat/webapps/ROOT.war

# Step 4: Expose port 8080 (Tomcat listens here)
EXPOSE 8080

# Step 5: Start Tomcat
CMD ["catalina.sh", "run"]

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Use it as CMD
CMD ["/usr/local/bin/docker-entrypoint.sh"]

