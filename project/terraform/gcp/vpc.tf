resource "google_compute_network" "vpc-project-2" {
  name                    = "${var.project_id}-vpc-project-2"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "mysubnet-project-2" {
  name          = "${var.project_id}-subnet-project-2"
  region        = var.region
  network       = google_compute_network.vpc-project-2.name
  ip_cidr_range = "10.10.0.0/24"
}
