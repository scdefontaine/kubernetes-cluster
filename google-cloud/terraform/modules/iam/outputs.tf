output "gke_sa_email" {
  value = google_service_account.gke-sa.email
}

output "service_account" {
  value = google_project_iam_member.service-account
}

output "service_account_custom" {
  value = google_project_iam_member.service-account-custom
}

output "bastion_sa_email" {
  value = google_service_account.bastion.email
}