# Keycloak legacy (wildfly) distribution
FROM quay.io/keycloak/keycloak:18.0.2-legacy

# Copy apple identity provider jar
COPY data/providers/apple-social-identity-provider-1.0.2.jar /opt/jboss/keycloak/standalone/deployments/

# Make the realm configuration available for import
COPY data/realms/realms.json /opt/jboss/keycloak/imports/

# The Keycloak server is configured to listen on port 8080
EXPOSE 8080
EXPOSE 8443

# Import the realm on start-up
ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]

# Import the realm and start
CMD ["-Dkeycloak.migration.action=import", "-Dkeycloak.migration.provider=singleFile", "-Dkeycloak.migration.file=/opt/jboss/keycloak/imports/realms.json", "-Dkeycloak.migration.strategy=IGNORE_EXISTING", "-b", "0.0.0.0"]