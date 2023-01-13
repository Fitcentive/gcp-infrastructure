# This needs to be created manually using the GCP console and imported manually using the following command
# tf import google_storage_bucket.terraform-remote-state-bucket fitcentive-dev/fitcentive-tf-state-nonproduction
resource "google_storage_bucket" "terraform-nonproduction-remote-state-bucket" {
  name          = "fitcentive-tf-state-nonproduction"
  force_destroy = false
  location      = local.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Terraform state bucket for DEV environment
resource "google_storage_bucket" "terraform-dev-remote-state-bucket" {
  name          = "fitcentive-tf-state-dev"
  force_destroy = false
  location      = local.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Enable required GCP APIs
resource "google_project_service" "gcp_services" {
  for_each = toset(local.gcp_service_list)
  project  = local.project_id
  service  = each.key
}

module "dev-terraform-service-account" {
  source = "../../modules/terraform-service-account"

  project_id = local.project_id
}

module "dev-firebase-project" {
  source = "../../modules/firebase"

  project_id           = local.project_id
  default_location     = local.firebase_location
  android_display_name = "Fitcentive Android Dev"
  android_package_name = "io.fitcentive.flutter_app"
  ios_bundle_id        = "io.fitcentive.flutterApp"
  ios_display_name     = "Fitcentive iOS Dev"
  web_display_name     = "Fitcentive Web Dev"
}
