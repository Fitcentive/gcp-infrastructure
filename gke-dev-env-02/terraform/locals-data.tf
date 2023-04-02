locals {
  project_id        = "fitcentive-dev-02"
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
  firebase_admin_service_account = "firebase-adminsdk-564kk"


  # Keycloak admin client config
  keycloak_admin_client_id = "admin-cli"
  # Change this value after navigating to keycloak server and generating a client secret
  # Required to change client access type to confidential
  keycloak_admin_client_secret   = "oQ7q322Ek4dn2tieS9DIlaPIfy8XISAC"
  keycloak_admin_client_username = "admin"
  # Change this value after navigating to keycloak server and setting up an admin password
  keycloak_admin_client_password = "WNgY1ftJblX9is3jSzi8JCJtNfaa5X"


  # Chat-service module specific credentials
  # Replace all these values with the right ones from Keycloak config
  # Realm -> Realm Settings -> Keys
  # Algorithm - RS256 (RSA)
  auth_server_url = "https://auth.fitcentive.xyz"

  # Apple Realm
  apple_auth_key_id     = "4dYwZWlrOtFxfzqnMF7i24dgwFtSHZkaop6zNuadeEA"
  apple_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjoaGDw3Cj6TmUPw4XM3wP5Zx52zl+2f3TR/T7z+LJkChL8SDZ5+xSt9M/0i4esQTizUDOpDJStrSI5FxUkIghY+NVF8+WU+m70inYZ/Qn7H5BpFPj0h90glgfYqXHnHAINP1IZovhTGReP6U64NTX6hiymdNPVzic2oHCktRtxU8x+s+G3fdcfLhi0wGL5BdX8hd4j1p2BLLeFFxA2SU37xgXp+odbWeLi9VNW5yEsKxi4Yn1EBuGwWBJyWe3bbVJNhqFai22ZJoc2OTjeVSvEC0CDkXnWO+qHD5WqBqDKfNFyzP4a0nlHjf0GENmsjdWendmELh4oX3i+Eb5HMTWwIDAQAB"

  # Facebook Realm
  facebook_auth_key_id     = "D2BREpDo1PRdK6eB2IDzlJDeJdmbhxOBun-c-zPnFgo"
  facebook_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAgpAcyIywcXEdc5TQFvZPAWA1pIy+6/as+3OXYxpMq+u+6WQzWB09sXc9hOWVKo34jZg2BdpSraAQKvskFZFP3XGqEJheWdjgIPErwhZkp6LyM4reQExRdAo0Tz3LuCz8CW6LYwiICWEEYNZL+csOmoBP1QL9tkcs2bWuPwyNg1vB+pLfwCOIcj7elQFd7dn/KkIBOPCyrftmV0UscKmu0A538VJtEs55E9uwOAUjC9Ol3kj2rnaLGz+tHPpwxsWLNYam3RyGZCX2tYMBuSfibtPueFtileCygTWeewL9zaAm6dTyrNTP+Y8M9Vua3jn4Mk7wtt05067uJmhpjz5a3QIDAQAB"

  # Google Realm
  google_auth_key_id     = "sJw2H-YRA0d5f3J5fUBq2Y5m5YZ5O3tSVaqal1KLX70"
  google_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAi61Spx70arMikuilfxvbMdZVHf6haZ4wna5mffZO1hXQzG1us7mS34nbTBPxRfRV0+UPx3SPVC0gOZsiFuY062GmmtZY2L0oBu6uZiJtGRc+4hhZzoNIwir1q18Zxepb0/DM+Oj891xxy7Yp8FPhyloG3kUradryFXQ69/cS+0dkOJ2WcbUD0zmpazeywMQ/MBZf0pJrEXjWk348e7L+yWl7884i2I3KIk8dP0Z2dMwXN8BqLSR6+cI1j9O4gdW/yudFqW7wm+8ELSJ+99M/bM015eWqZ+IPVGjJIFYmAVXZcpt1/EHIRValcvsTcTPhhivrDeRqtx7Mr3LANVPaSQIDAQAB"

  # Native Realm
  native_auth_key_id     = "FvVQglTSr4F98GxVSO930wTDSdkTTCntPpjA6gICv9k"
  native_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnwxrlR45xYuj77wJu3sIZqYmv7tcb0/p68E8mhz8VyAfEzdSTLko9dtruyUbmy6yhEDlzp5wJDnJmrSv/8R23zucJ/SjcdhJuwHSIF2se2eMKHTM2KP9B/KDcAk0hcHduzqC3JKDkj0aHgBgduBH+3Jpnye13j2FqbnBtoFIny1AlmHlCey7igr8UjZK+vikdufz7KeHgMjQJbrho3QhQo7zzunr90szwC+1CH95ZQl5Y6qzn74mg19tDoZJMMAgtimU6Rer8P5DcuTPG/hCV2VPw9Qx9aw0VkvzXomanzCC90e5rWjvWTQQlIzqC0l/sIogph9kkNqKD1Y6U4x42QIDAQAB"

  # Fatsecret API detail
  fatsecret_client_secret = "5dfd8128ad9241bfa64fc7f793e84775"
  fatsecret_client_id     = "305dd9e4c424408982f069ae60453cdc"

}