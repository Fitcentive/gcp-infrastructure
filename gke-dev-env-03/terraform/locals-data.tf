locals {
  project_id        = "fitcentive-dev-03"
  region            = "northamerica-northeast2"
  firebase_location = "northamerica-northeast1"
  zone              = "northamerica-northeast2-a"

  secondary_namespaces = [
    "image-service",
    "image-proxy"
  ]

  service_namespaces = [
    "chat",
    "auth",
    "notification",
    "user",
    "social",
    "public-gateway",
    "discover",
    "meetup",
    "diary",
    "scheduler",
    "awards",
    # Web namespace used for flutter-web-app
    "web"
  ]

  # Neo4j Config
  neo4j_db_name  = "FitcentiveGraphDb"
  neo4j_password = "svcX494RgXZQGyCm4bDbrF2cbzOPDkKUUnS_3lnJJ9M"
  neo4j_uri      = "neo4j+s://50af67f7.databases.neo4j.io"
  neo4j_username = "neo4j"

  # Note - the following value is fetched from https://console.firebase.google.com/u/1/project/fitcentive-dev/settings/serviceaccounts/adminsdk
  # This value is created when parent `nonproduction` project's `module.dev-firebase-project` is executed successfully
  # Refer to the README.adoc for more info on how to set this value appropriately
  firebase_admin_service_account = "firebase-adminsdk-j2shj"


  # Keycloak admin client config
  keycloak_admin_client_id = "admin-cli"
  # Change this value after navigating to keycloak server and generating a client secret
  # Required to change client access type to confidential
  keycloak_admin_client_secret   = "82xfIQcccHbtwPY8BHDhSfMTvIfdBjo5"
  keycloak_admin_client_username = "admin"
  # Change this value after navigating to keycloak server and setting up an admin password
  keycloak_admin_client_password = "WNgY1ftJblX9is3jSzi8JCJtNfaa5X"


  # Chat-service module specific credentials
  # Replace all these values with the right ones from Keycloak config
  # Realm -> Realm Settings -> Keys
  # Algorithm - RS256 (RSA)
  auth_server_url = "https://auth.fitcentive.xyz"

  # Apple Realm
  apple_auth_key_id     = "mDGHdDD6XDe73eC4YyZvOvW94SFEP9DrOHwvwD3YOdM"
  apple_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkYjCtdBhlhu88fsRPeUIlcIDK2SoS2y9nd3o2SbAHdQFKGFgKsvXzJqCU/LOWEgS1g3e6ZKloHDVkIE+o3rph3U9KAGMN6tpdm85AZUpOdzJRzZ3PxSDLOwBut4CYxVIGIJs7P7BOoNPB1j+Gl83r7sK1jzkgOEbw237eOv///71GcUC8V+TiWZjL39vg4nmhvsqdVSZoN2+TohjNFEiqvjQO02Opa/CiqRRnsVaxCRU6a25EBYG2/4b7TEBsqqr3aCTFfnyNy8p/IhRYQzQqTcUR3V1CSrGnHbK2dnxh6Ymo4IhSDh7HbAHMz1icvYB21No1GrVEpf4g3dWslyPQQIDAQAB"

  # Facebook Realm
  facebook_auth_key_id     = "D2BREpDo1PRdK6eB2IDzlJDeJdmbhxOBun-c-zPnFgo"
  facebook_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAgpAcyIywcXEdc5TQFvZPAWA1pIy+6/as+3OXYxpMq+u+6WQzWB09sXc9hOWVKo34jZg2BdpSraAQKvskFZFP3XGqEJheWdjgIPErwhZkp6LyM4reQExRdAo0Tz3LuCz8CW6LYwiICWEEYNZL+csOmoBP1QL9tkcs2bWuPwyNg1vB+pLfwCOIcj7elQFd7dn/KkIBOPCyrftmV0UscKmu0A538VJtEs55E9uwOAUjC9Ol3kj2rnaLGz+tHPpwxsWLNYam3RyGZCX2tYMBuSfibtPueFtileCygTWeewL9zaAm6dTyrNTP+Y8M9Vua3jn4Mk7wtt05067uJmhpjz5a3QIDAQAB"

  # Google Realm
  google_auth_key_id     = "sJw2H-YRA0d5f3J5fUBq2Y5m5YZ5O3tSVaqal1KLX70"
  google_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAi61Spx70arMikuilfxvbMdZVHf6haZ4wna5mffZO1hXQzG1us7mS34nbTBPxRfRV0+UPx3SPVC0gOZsiFuY062GmmtZY2L0oBu6uZiJtGRc+4hhZzoNIwir1q18Zxepb0/DM+Oj891xxy7Yp8FPhyloG3kUradryFXQ69/cS+0dkOJ2WcbUD0zmpazeywMQ/MBZf0pJrEXjWk348e7L+yWl7884i2I3KIk8dP0Z2dMwXN8BqLSR6+cI1j9O4gdW/yudFqW7wm+8ELSJ+99M/bM015eWqZ+IPVGjJIFYmAVXZcpt1/EHIRValcvsTcTPhhivrDeRqtx7Mr3LANVPaSQIDAQAB"

  # Native Realm
  native_auth_key_id     = "SgG8h1bm6UFuni7fsAX-PeVLBNApL_G5MrwJBTWNCxc"
  native_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjgs8d0zBYbCRJErK0YWHEmUa8ipixyKDYQPiWSqQH8lAlWhMbRwk1asU6gKbzy4tyNKoaLkD7RnIBX8ahx+nktCEzw4PqTKDyGoYh56rgPlkJ8LjtX46hur9CUs0jLoDWBFTybMT/OibYsiTRPU9jpv/UzMYjtoMufERuMxyjDA8boCOFfuWvhlPD2OnBe7EHZGu9YJX5yHSgFWv6pLMh1XpoYZyND2cKb65PTygSQNh7Do5LjiffE0bt7DcBQBoCS/Mkh26Yo3xris1tRIzhDWrZaAn/2bGF4SeJ8r6RvsI1l0e4l8yhIOdQMEdAwY/IwjS3ItwbQHdGKFwz6E16QIDAQAB"

  # Fatsecret API detail
  fatsecret_client_secret = "5dfd8128ad9241bfa64fc7f793e84775"
  fatsecret_client_id     = "305dd9e4c424408982f069ae60453cdc"

  # AdMob config
  ad_unit_id_android = "ca-app-pub-3940256099942544/6300978111"
  ad_unit_id_ios     = "ca-app-pub-3940256099942544/2934735716"

  # MailJet SMTP config
  mailjet_smtp_host = "in-v3.mailjet.com"
  mailjet_smtp_port = "587"
  # This value is the API key from mailjet - https://app.mailjet.com/account/relay
  mailjet_smtp_user = "c97324bd1ac6e563eef5424c278d5d05"
  # This value is the associated secret with the API key above - https://app.mailjet.com/account/relay
  mailjet_smtp_password = "e6d38f5fedb15725a7e89db05fd7b32c"

}