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
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  backend "gcs" {
    # See nonproduction/terraform/outputs for info on this
    bucket = "fitcentive-03-tf-state-dev"
    prefix = "terraform/state"
  }

  required_version = ">= 0.14"
}

data "terraform_remote_state" "tf_remote_state_dev" {
  backend = "gcs"
  config = {
    bucket = "fitcentive-03-tf-state-dev"
    prefix = "terraform/state"
  }
}

data "terraform_remote_state" "tf_remote_state_nonproduction" {
  backend = "gcs"
  config = {
    bucket = "fitcentive-03-tf-state-nonproduction"
    prefix = "terraform/state"
  }
}

data "google_client_config" "default" {}

provider "google" {
  project     = local.project_id
  region      = local.region
  credentials = base64decode(data.terraform_remote_state.tf_remote_state_nonproduction.outputs.tf_service_account_private_key)
}

provider "google-beta" {
  project     = local.project_id
  region      = local.region
  credentials = base64decode(data.terraform_remote_state.tf_remote_state_nonproduction.outputs.tf_service_account_private_key)
}

provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.tf_remote_state_nonproduction.outputs.gke_dev_kubernetes_cluster_host}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.tf_remote_state_nonproduction.outputs.gke_dev_kubernetes_cluster_ca_certificate)
}

provider "kubectl" {
  load_config_file       = false
  host                   = "https://${data.terraform_remote_state.tf_remote_state_nonproduction.outputs.gke_dev_kubernetes_cluster_host}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.tf_remote_state_nonproduction.outputs.gke_dev_kubernetes_cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.terraform_remote_state.tf_remote_state_nonproduction.outputs.gke_dev_kubernetes_cluster_host}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.tf_remote_state_nonproduction.outputs.gke_dev_kubernetes_cluster_ca_certificate)
  }
}