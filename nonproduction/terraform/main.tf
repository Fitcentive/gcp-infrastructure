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
  ios_display_name     = "Fitcentive iOS Dev"
  android_display_name = "Fitcentive Android Dev"
  web_display_name     = "Fitcentive Web Dev"
  ios_bundle_id        = "io.fitcentive.flutterApp"
  android_package_name = "io.fitcentive.flutter_app"

  # Depends on service account module as the google-beta provider uses created service account as credentials via remote state
  # The firebase provider cannot authenticate via default creds, only service_account for now
  # Refer to provider `google-beta` credentials in `provider.tf` for more info
  depends_on = [
    module.dev-terraform-service-account
  ]
}

module "gke-dev-env" {
  source = "../../modules/kubernetes-cluster"

  project_id = local.project_id
  region     = local.region
  zone       = local.zone

  gke_num_nodes = 1
}

