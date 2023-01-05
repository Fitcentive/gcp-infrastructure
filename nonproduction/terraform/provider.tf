terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.46.0"
    }
  }

  backend "gcs" {
    bucket = "p2m-tf-state-nonproduction"
    prefix = "terraform/state"
  }

  required_version = ">= 0.14"
}

data "terraform_remote_state" "tf-remote-state-nonproduction" {
  backend = "gcs"
  config = {
    bucket = "p2m-tf-state-nonproduction"
    prefix = "terraform/state"
  }
}

data "google_client_config" "default" {}

# This uses application default credentials configured via gcloud auth
provider "google" {
  project = local.project_id
  region  = local.region
}
