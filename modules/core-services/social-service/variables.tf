variable "namespace" {
  type    = string
  default = "social"
}

variable "service_name" {
  type    = string
  default = "social-service"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "neo4j_uri" {
  description = "Neo4j Database URI"
}

variable "neo4j_username" {
  description = "Neo4j Database username"
}

variable "neo4j_password" {
  description = "Neo4j Database password"
}

variable "neo4j_db_name" {
  description = "Neo4j Database name"
}