// Create the GKE service account
resource "google_service_account" "gke-sa" {
  account_id   = format("%s-node-sa", var.cluster_name)
  display_name = "GKE Security Service Account"
  project      = var.project
}

// Add the service account to the project
resource "google_project_iam_member" "service-account" {
  count   = length(var.service_account_iam_roles)
  project = var.project
  role    = element(var.service_account_iam_roles, count.index)
  member  = format("serviceAccount:%s", google_service_account.gke-sa.email)
}

// Add bastion service account to the project
resource "google_project_iam_member" "service-account-custom" {
  count   = length(var.bastion_sa_iam_roles)
  project = var.project
  role    = element(var.bastion_sa_iam_roles, count.index)
  member  = format("serviceAccount:%s", google_service_account.bastion.email)
}

// Dedicated service account for the Bastion instance
resource "google_service_account" "bastion" {
  account_id   = format("%s-bastion-sa", var.cluster_name)
  display_name = "GKE Bastion SA"
  project      = var.project
}