output "network_link" {
  value = google_compute_network.network.self_link
}

output "network_name" {
  value = google_compute_network.network.name
}

output "subnetwork_link" {
  value = google_compute_subnetwork.subnetwork.self_link
}

output "subnetwork_name" {
  value = google_compute_subnetwork.subnetwork.name
}

output "subnetwork_ip_range_0_name" {
  value = google_compute_subnetwork.subnetwork.secondary_ip_range.0.range_name
}

output "subnetwork_ip_range_1_name" {
  value = google_compute_subnetwork.subnetwork.secondary_ip_range.1.range_name
}

output "project_service" {
  value = google_project_service.service
}

output "nat_router" {
  value = google_compute_router_nat.nat
}
