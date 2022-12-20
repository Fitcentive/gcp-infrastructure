# todo - make remote state bucket create over here too

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${local.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${local.project_id}-subnet"
  region        = local.region

  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${local.project_id}-gke"
  location = local.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}"
  location   = local.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = local.project_id
    }

    preemptible  = true
    machine_type = "e2-standard-4"
    tags         = ["gke-node", "${local.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}


