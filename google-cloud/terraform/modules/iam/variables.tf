// Required values to be set in terraform.tfvars
variable "project" {
  description = "The project in which to hold the components"
}

variable "cluster_name" {
  description = "The name to give the new Kubernetes cluster."
}

variable "service_account_iam_roles" {
  description = <<-EOF
  List of the default IAM roles to attach to the service account on the
  GKE Nodes.
  EOF
}

variable "bastion_sa_iam_roles" {
  default = []

  description = <<-EOF
  List of arbitrary additional IAM roles to attach to the service account on
  the GKE nodes.
  EOF
}
