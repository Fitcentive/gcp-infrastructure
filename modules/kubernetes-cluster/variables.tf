variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "gke_machine_type" {
  default     = "e2-standard-4"
  description = "GKE machine type. Check GCE options for more info"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "region" {
  description = "GCP deploy region"
}

variable "zone" {
  description = "GCP deploy zone"
}