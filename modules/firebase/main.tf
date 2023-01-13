resource "google_firebase_project" "dev-firebase-project" {
  provider = google-beta
  project  = var.project_id
}

resource "google_firebase_project_location" "basic" {
  provider = google-beta
  project  = var.project_id

  location_id = var.default_location

  depends_on = [
    google_firebase_project.dev-firebase-project
  ]
}


resource "google_firebase_android_app" "dev-android-app" {
  provider     = google-beta
  project      = var.project_id
  display_name = var.android_display_name
  package_name = var.android_package_name

  depends_on = [
    google_firebase_project.dev-firebase-project
  ]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/firebase_apple_app for more options
resource "google_firebase_apple_app" "dev-ios-app" {
  provider     = google-beta
  project      = var.project_id
  display_name = var.ios_display_name
  bundle_id    = var.ios_bundle_id

  depends_on = [
    google_firebase_project.dev-firebase-project
  ]
}

resource "google_firebase_web_app" "dev-web-app" {
  provider        = google-beta
  project         = var.project_id
  display_name    = var.web_display_name
  deletion_policy = "DELETE"

  depends_on = [
    google_firebase_project.dev-firebase-project
  ]
}

data "google_firebase_web_app_config" "dev-web-config" {
  provider   = google-beta
  web_app_id = google_firebase_web_app.dev-web-app.app_id
}