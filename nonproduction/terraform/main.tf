# This needs to be created manually using the GCP console and imported manually using the following command
# tf import google_storage_bucket.terraform-remote-state-bucket place-2-meet-dev/p2m-tf-state-nonproduction
resource "google_storage_bucket" "terraform-nonproduction-remote-state-bucket" {
  name          = "p2m-tf-state-nonproduction"
  force_destroy = false
  location      = local.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Terraform state bucket for DEV environment
resource "google_storage_bucket" "terraform-dev-remote-state-bucket" {
  name          = "p2m-tf-state-dev"
  force_destroy = false
  location      = local.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

module "dev-terraform-service-account" {
  source = "../../modules/terraform-service-account"

  project_id = local.project_id
}