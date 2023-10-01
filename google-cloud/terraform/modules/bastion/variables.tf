variable "project" {
  description = "The project in which to hold the components"
}

variable "region" {
  description = "The region in which to create the VPC network"
}

variable "zone" {
  description = "The zone in which to create the VPC network"
}

variable "cluster_name" {
  description = "The name to give the new Kubernetes cluster."
}

variable "network_name" {
  description = "The name of the cluster network"
}

variable "subnetwork_name" {
  description = "The name of the cluster sub network"
}

variable "bastion_sa_email" {
  description = "The email address for the bastion service account"
}

variable "bastion_tags" {
  description = "A list of tags applied to your bastion instance."
}