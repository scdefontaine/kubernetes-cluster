
resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  project  = var.project
  location = var.region

  network    = var.network_link
  subnetwork = var.subnetwork_link

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  // Decouple the default node pool lifecycle from the cluster object lifecycle
  // by removing the node pool and specifying a dedicated node pool in a
  // separate resource below.
  remove_default_node_pool = "true"
  initial_node_count       = 1

  // Configure various addons
  addons_config {
    // Disable the Kubernetes dashboard, which is often an attack vector. The
    // cluster can still be managed via the GKE UI.
    # kubernetes_dashboard {
    #   disabled = true
    # }

    // Enable network policy (Calico)
    network_policy_config {
      disabled = false
    }
  }

  // Enable workload identity
  workload_identity_config {
    workload_pool = format("%s.svc.id.goog", var.project)
  }

  // Disable basic authentication and cert-based authentication.
  // Empty fields for username and password are how to "disable" the
  // credentials from being generated.
  master_auth {

    client_certificate_config {
      issue_client_certificate = "false"
    }
  }

  // Enable network policy configurations (like Calico) - for some reason this
  // has to be in here twice.
  network_policy {
    enabled = "true"
  }

  // Allocate IPs in our subnetwork
  ip_allocation_policy {
    # use_ip_aliases                = true
    cluster_secondary_range_name  = var.subnetwork_ip_range_0_name
    services_secondary_range_name = var.subnetwork_ip_range_1_name
  }

  // Specify the list of CIDRs which can access the master's API
  master_authorized_networks_config {
    cidr_blocks {
      display_name = "bastion"
      cidr_block   = format("%s/32", var.bastion_network_ip)
    }
  }
  // Configure the cluster to have private nodes and private control plane access only
  private_cluster_config {
    enable_private_endpoint = "true"
    enable_private_nodes    = "true"
    master_ipv4_cidr_block  = "172.16.0.16/28"
  }

  // Allow plenty of time for each operation to finish (default was 10m)
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  depends_on = [
    var.project_service,
    var.service_account,
    var.service_account_custom,
    var.nat_router
  ]

}

// A dedicated/separate node pool where workloads will run.  A regional node pool
// will have "node_count" nodes per zone, and will use 3 zones.  This node pool
// will be 3 nodes in size and use a non-default service-account with minimal
// Oauth scope permissions.
resource "google_container_node_pool" "private-np-1" {
  name       = "${var.cluster_name}-private-np-1"
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = "1"

  // Repair any issues but don't auto upgrade node versions
  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    machine_type = "n1-standard-2"
    disk_type    = "pd-ssd"
    disk_size_gb = 30
    image_type   = "COS"

    // Use the cluster created service account for this node pool
    service_account = var.gke_sa_email

    // Use the minimal oauth scopes needed
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]

    labels = {
      cluster = var.cluster_name
    }

    // Enable workload identity on this node pool
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    metadata = {
      // Set metadata on the VM to supply more entropy
      google-compute-enable-virtio-rng = "true"
      // Explicitly remove GCE legacy metadata API endpoint
      disable-legacy-endpoints = "true"
    }
  }

  depends_on = [
    google_container_cluster.cluster
  ]
}