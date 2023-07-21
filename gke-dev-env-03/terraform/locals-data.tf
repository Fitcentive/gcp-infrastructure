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
  keycloak_admin_client_secret   = "pvI27F5uFfqhe94LKAmpxpcKGwWI7S2U"
  keycloak_admin_client_username = "admin"
  # Change this value after navigating to keycloak server and setting up an admin password
  keycloak_admin_client_password = "WNgY1ftJblX9is3jSzi8JCJtNfaa5X"


  # Chat-service module specific credentials
  # Replace all these values with the right ones from Keycloak config
  # Realm -> Realm Settings -> Keys
  # Algorithm - RS256 (RSA)
  auth_server_url = "https://auth.fitcentive.xyz"

  # Apple Realm
  apple_auth_key_id     = "q3EgEeok2HRYy_2w7-ikT87S54e_mms85KxFhVgdPOk"
  apple_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx9WEEWJeVJR/36M3zi2kOMy11yddKAZnVlfUQznhjn3ZDEvV+5dT9pS4H5YWva816lGqWwgCokk/DZs9PE/QNkSJkQ+khcsc/u1Twi96hSHLsFE4vXPhOluURpJFxzAmP11/0zzJlWmShoiaxy5xUZh5jek6YppBsFyXrOmOogY09+w+HU6QS+x+MyVuE+o6EcQJnLBVGibxMnJ8NbK0vUlDJeVWb81qVcEslR8i1VHvmNE2Blc60vicoqqk1sj52+qNku2v9iHacDbngwt25ZJ0j80XaGLI6zemDZu5FZXtiJhxM7RpwIpLxPhLXzuJXxhqCAU4HoDjyISIRoCcXQIDAQAB"

  # Facebook Realm
  facebook_auth_key_id     = "eRkPkSZ0nb3LGPj2B0VuowI4aaNkG-aXyoIfKgddu5M"
  facebook_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjSpKbNVSLtbmMQW6W4H5OI3ZgOsYOp5BC39xM2Elc5IlM+PN5m73tesLhChEvr7pOvO85P4LxUutIHcSCVudAkH2ANhR8WZv+b1Cnh6Ggvuk37A5JIu7ydlFyvMNGqNlqGBZniT6EkFV1dnTVMGdS4PV3Aj7lk7oKJuUwxu45A+ciCc9AevMpBjccO09znXpPf13ZRrzueAgrZuBXHj7OE8++aEaI4TjGcVgvTHT8sEnGSXbVaKeocAeJ16yBG4T43zkFLWrll1vfv/qzAMq9U81+0U5FIDFSrQxMllUGWysl2WbA2z42eJRYkDfQcsUdd2BHSWtPLCxxSW9Knh40QIDAQAB"

  # Google Realm
  google_auth_key_id     = "3YnNf6PGJJg2sHsGRo_JRZEtY8WHfGIREmym3tumsx4"
  google_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAo/MiWNkS8vJYihCHxAQgJ5bbXBBgMjV9yhKJJvepx2+rVHtBM6b9j/vqT27BBFRc7aV+S9XnOqKFLyL/F64vohgAqCXW2I28d/cN9CQBioGmg4lfEPLee9H6NkCo+Z8Jut3MbTi5rzS1XXDlDaIDte5vQnyV6oSWootnIMRZyc2kSUAajbpR1o6CER7H4iFDyD/KaNWSRNKYRT+S+IShiF2fdYZOCKtBB3S6FWXBDOYYg7y7FEtwqasVa82Sk3J8T9ibarSc6ffnpVm4ROLqQ3Y4kI3lXyy+d+klRqMIVeQYDy5pI7ojm7BpBAsj0Xa8erO/jub+Jr8SfNeVycZ5/wIDAQAB"

  # Native Realm
  native_auth_key_id     = "1hRQEVU51IGMEJmu4uhtfjUqdQUS9uAKNR2QpVnGhfQ"
  native_auth_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr6a3UZvZD+CDpS5foABwCn8p8+IBkcCBgqsciqPBh56WlRlf4U01pa2RQ7ZUiyVDo88w7g9GQqdtjuiyGluJvLm7Mxc1jFAxEifY0Txtn1/U5947mcCxY7pNX2UPLcu1dcLF4YrLkUjvEkct5NOE8YErMl6rK33sjLY1+/5Zt37UMu1om0vLD2x4ep7nK8gqiNua+QtIi4gVMSh8YoGWt7AqngslicT+AE9cZDJEKX1S0djB2iVk/wFObqoDojx1WtZzjR51tSIFDSSBxRVZjTL4ryefh1ZqpJ5Q0XS6RWJkPS4H/7r+YgtCrdeL8VZ3K8mSoYO7mw2W/W0bSkjSowIDAQAB"

  # Fatsecret API detail
  fatsecret_client_secret = "5dfd8128ad9241bfa64fc7f793e84775"
  fatsecret_client_id     = "305dd9e4c424408982f069ae60453cdc"

  # AdMob config
  ad_unit_id_android = "ca-app-pub-3940256099942544/6300978111"
  ad_unit_id_ios     = "ca-app-pub-3940256099942544/2934735716"

}