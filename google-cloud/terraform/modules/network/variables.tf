// Required values to be set in terraform.tfvars
variable "project" {
  description = "The project in which to hold the components"
}

variable "region" {
  description = "The region in which to create the VPC network"
}

variable "cluster_name" {
  description = "The name to give the new Kubernetes cluster."
}

variable "project_services" {
  description = <<-EOF
  The GCP APIs that should be enabled in this project.
  EOF
}