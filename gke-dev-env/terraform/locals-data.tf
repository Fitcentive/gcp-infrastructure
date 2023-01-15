locals {
  project_id        = "fitcentive-dev"
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
  ]

  # Neo4j Config
  neo4j_db_name  = "FitcentiveGraphDb"
  neo4j_password = "svcX494RgXZQGyCm4bDbrF2cbzOPDkKUUnS_3lnJJ9M"
  neo4j_uri      = "neo4j+s://50af67f7.databases.neo4j.io"
  neo4j_username = "neo4j"

  # Note - the following value is fetched from https://console.firebase.google.com/u/1/project/fitcentive-dev/settings/serviceaccounts/adminsdk
  # This value is created when parent `nonproduction` project's `module.dev-firebase-project` is executed successfully
  # Refer to the README.adoc for more info on how to set this value appropriately
  firebase_admin_service_account = "firebase-adminsdk-7jk1g"


  # Keycloak admin client config
  keycloak_admin_client_id       = "admin-cli"
  # Change this value after navigating to keycloak server and generating a client secret
  # Required to change client access type to confidential
  keycloak_admin_client_secret   = "yqkH4WpiiEgk6Yl1F2CQ54O1nZQfWAui"
  keycloak_admin_client_username = "admin"
  # Change this value after navigating to keycloak server and setting up an admin password
  keycloak_admin_client_password = "WNgY1ftJblX9is3jSzi8JCJtNfaa5X"


  # Chat-service module specific credentials
  # Replace all these values with the right ones from Keycloak config
  # Realm -> Realm Settings -> Keys
  # Algorithm - RS256 (RSA)
  auth_server_url = "https://auth.fitcentive.xyz"

  # Apple Realm
  apple_auth_key_id = "kdBwOzLYbKo9dlr_kr03KRkaDPoYNZ3Xpqs9U0jNGqA"
  apple_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlKMZkMgS1JnYz+Y/MiQxT6aZRjg75x3f8RqWsQUxH1F4ANuTigEnL9/jPc4wLAsPdMOeOYuy/Ep9OLufkiLwHKjy2Va9Sl6I+HgXE18fdtP5vIjtcLaGy4YZiFVGdrLJIOcDE8rnZngMnrmBtGjrop0aeywtEGY9jvKofYpyoTX+hIcYd6JsxJAvc6QJ0JsqtfX3iXiLwElGphKdQUNBqFdUNzFou/jcmpQSrsn5mpbQjN0+gmOBDnfQBOmHqxmkr0pNeAiKxnOe6UNM7ELphQ/tr07PVTOiKFsGsavHDT+SydhOPjjZn0oCTeKV1g5/3TUxpV0k4jSf60YYjTab0wIDAQAB"

  # Facebook Realm
  facebook_auth_key_id = "vysHURgY5NuxAKoTq6waZ5qETxZxYwEwI0Mp460yuHo"
  facebook_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt+5aeXdHctmwGkqtLsSAkk6jReNYEvwO6sdG7uA0YnMhVrD+EqWe3K+2wJR5sXLOuA73dPYEjcpX9/+mDqrQJGhoXBbyEsirDOr0fgbsiMQHIPnYj9JqU30JYNxDp2MlAIQgBYTkBk/nDqJUa1GIRKb9COipguqHrRMThq0BQPrU5m8+vyeg95g7tnmoIzrEhD3iCeQWAaJlHyqJg4wchqcx375etEnSBEqzYsmjngh1tiguEX2mYpyN9Pkd8K6vmkn3Elu65bQT+mzIOiSswh93OvrfHMLGfjSxkqJHLTPd7WRohYPxTov/egW2RPPAEoagF35VseLnh+O+BhcBvQIDAQAB"

  # Google Realm
  google_auth_key_id = "5wDDGxckPPJeBhbo5tf-veLtoR9pDHkQ8_KoWsKuAZs	"
  google_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAljdmskQLn+qVUHD2mcvb2tPL3qYuE0q/ZtXEJo4TzGpXIuIL7u+zOUBxBe25zabbC43k6V7QjzwUGHwhNYsGnpA9y166+Kik6+EJnyreAopTvtQHI3LVKwfAbW44SZslplnqOe2DZH6MqKxKd2M3k155qdbGFcZprhNYUIxT5zTO0I+yUXP+D6xjsvKbABn66tHhBgAaUNNwbqrsnSMMJvTCk5+kaeRmjWNdN1MDiE5IOSLsdjHfH4fxXvoQ9ooL3AZ0SaydpYjbI4BIYkUEPIr+HlmBrdgnDOG9Mlfo2/mwZ49g0YG6mX6bUIPyqzXbhTycoPwXdNVGYsU+rrmvVwIDAQAB"

  # Native Realm
  native_auth_key_id = "BI_1W6LxNEA0_RLUQOQni6WMcogsxLoHUXWqGnt8720"
  native_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkeJv04Sj5ZwJpF42CuanveyN4YRQKehWJIUEA58xV0R3ayN6nIn2nK5ai8GTrokVto7rx43OC4ycMbH6O4kH1bJvcDsUVV2MXm/X+H+G5cCqQGS25Wj6t0f+2jQ0+mEIH/X9PpJixfa4LDUjnFS/LjtUR/vZ4FsrVyIsKT23LQ8lzmvdil4gYvPJwj0uSbDjSjAwXSxn9xVUFfuC5eLZ2siraql6oKVDdLx+B5kRSOOVMwTy45/Q3fEaCYMbjENE0rQ+fQiBE8fg3GQEzBhlbAfatiUNRtcrUd6625OKEOXFsNwK8YCHbf4uhMvQqZrVcANYHRTa8uzpdUNAA5cEJwIDAQAB"
}