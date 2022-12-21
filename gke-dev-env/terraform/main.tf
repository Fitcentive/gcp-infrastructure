# Terraform state bucket
resource "google_storage_bucket" "terraform-remote-state-bucket" {
  name          = "p2m-tf-state-dev"
  force_destroy = false
  location      = local.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# GKE cluster
module "place-2-meet-dev-gke" {
  source = "../../modules/kubernetes-cluster"

  project_id = local.project_id
  region     = local.region
  zone       = local.zone
}