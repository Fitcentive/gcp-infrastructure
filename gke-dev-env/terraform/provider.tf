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

data "google_client_config" "default" {}

provider "google" {
  project = local.project_id
  region  = local.region
}

# do we have to actually split into parent-child projects!?
provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.tf_remote_state_dev.outputs.kubernetes_cluster_host}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.tf_remote_state_dev.outputs.kubernetes_cluster_ca_certificate)
}

provider "kubectl" {
  load_config_file       = false
  host                   = "https://${data.terraform_remote_state.tf_remote_state_dev.outputs.kubernetes_cluster_host}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.tf_remote_state_dev.outputs.kubernetes_cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.terraform_remote_state.tf_remote_state_dev.outputs.kubernetes_cluster_host}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.tf_remote_state_dev.outputs.kubernetes_cluster_ca_certificate)
  }
}