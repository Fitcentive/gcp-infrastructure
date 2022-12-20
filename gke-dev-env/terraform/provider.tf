terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.46.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.15"
    }
  }

  backend "gcs" {
    bucket  = "p2m-tf-state-dev"
    prefix  = "terraform/state"
  }

  required_version = ">= 0.14"
}

data "terraform_remote_state" "tf_remote_state_dev" {
  backend = "gcs"
  config = {
    bucket  = "p2m-tf-state-dev"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
}

provider "kubernetes" {
  load_config_file = "false"
  host             = data.terraform_remote_state.tf_remote_state_dev.outputs.kubernetes_cluster_host

  client_certificate     = base64decode(data.terraform_remote_state.tf_remote_state_dev.outputs.kubernetes_client_cert)
  client_key             = base64decode(data.terraform_remote_state.tf_remote_state_dev.outputs.kubernetes_client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.tf_remote_state_dev.outputs.kubernetes_cluster_ca_certificate)
}