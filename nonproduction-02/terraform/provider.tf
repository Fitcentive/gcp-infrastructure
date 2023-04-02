terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.46.0"
    }
  }

  backend "gcs" {
    bucket = "fitcentive-02-tf-state-nonproduction"
    prefix = "terraform/state"
  }

  required_version = ">= 0.14"
}

data "terraform_remote_state" "tf-remote-state-nonproduction" {
  backend = "gcs"
  config = {
    bucket = "fitcentive-02-tf-state-nonproduction"
    prefix = "terraform/state"
  }
}

data "google_client_config" "default" {}

# This uses application default credentials configured via gcloud auth
provider "google" {
  project = local.project_id
  region  = local.region
}

# This uses application terraform service account credentials
provider "google-beta" {
  project     = local.project_id
  region      = local.region
  credentials = base64decode(data.terraform_remote_state.tf-remote-state-nonproduction.outputs.tf_service_account_private_key)
}