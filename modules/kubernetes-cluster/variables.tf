variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
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