
locals {
  project         = "sean-defontaine"
  region          = "us-central1"
  zone            = "us-central1-c"
  cluster_name    = "kube-cluster"
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
}

provider "google-beta" {
  project = local.project
  region  = local.region
  zone    = local.zone
}

module "network" {
  source              = "./modules/network"
  project             = local.project
  region              = local.region
  cluster_name        = local.cluster_name
  project_services    = [
                        "cloudresourcemanager.googleapis.com",
                        "servicenetworking.googleapis.com",
                        "container.googleapis.com",
                        "compute.googleapis.com",
                        "iam.googleapis.com",
                        "logging.googleapis.com",
                        "monitoring.googleapis.com",
                        "securetoken.googleapis.com",
                      ]
}

module "iam" {
  source                              = "./modules/iam"
  project                             = local.project
  cluster_name                        = local.cluster_name
  service_account_iam_roles           = [
                                        "roles/logging.logWriter",
                                        "roles/monitoring.metricWriter",
                                        "roles/monitoring.viewer",
                                        "roles/compute.viewer"
                                      ]
  bastion_sa_iam_roles    = [
                                        "roles/logging.logWriter",
                                        "roles/monitoring.metricWriter",
                                        "roles/monitoring.viewer",
                                        "roles/compute.viewer"
                                      ]
}

module "bastion" {
  source            = "./modules/bastion"
  project           = local.project
  region            = local.region
  zone              = local.zone
  cluster_name      = local.cluster_name

  network_name      = module.network.network_name
  subnetwork_name   = module.network.subnetwork_name

  bastion_sa_email  = module.iam.bastion_sa_email
  bastion_tags      = ["bastion"]

  depends_on = [
    module.network,
    module.iam
  ]
}

module "cluster" {
  source                      = "./modules/gke"
  project                     = local.project
  region                      = local.region
  cluster_name                = local.cluster_name

  project_service             = module.network.project_service
  network_link                = module.network.network_link
  subnetwork_link             = module.network.subnetwork_link
  subnetwork_ip_range_0_name  = module.network.subnetwork_ip_range_0_name
  subnetwork_ip_range_1_name  = module.network.subnetwork_ip_range_1_name
  nat_router                  = module.network.nat_router

  service_account             = module.iam.service_account
  service_account_custom      = module.iam.service_account_custom
  gke_sa_email                = module.iam.gke_sa_email

  bastion_network_ip          = module.bastion.bastion_network_ip

  depends_on = [
    module.network,
    module.iam,
    module.bastion
  ]
}