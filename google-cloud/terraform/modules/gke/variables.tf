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

variable "project_service" {
  description = "Link to project service"
}

variable "network_link" {
  description = "Self link to google compute network"
}

variable "subnetwork_link" {
  description = "Self link to google compute sub network"
}

variable "subnetwork_ip_range_0_name" {
  description = "Sub network IP Range 0 Name"
}

variable "subnetwork_ip_range_1_name" {
  description = "Sub network IP Range 1 Name"
}

variable "nat_router" {
  description = "Link to nat router"
}

variable "service_account" {
  description = "Link to service account"
}

variable "service_account_custom" {
  description = "Link to service account custom"
}

variable "gke_sa_email" {
  description = "GKE Service Account Email"
}

variable "bastion_network_ip" {
  description = "IP Address of the bastion instance"
}

