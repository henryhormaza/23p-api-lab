#Backend Config
terraform {
  backend "gcs" {
    credentials = "core-waters-284316-892e73a3a61b.json"
    bucket = "tf-state-23people"
    prefix = "terraform/state"
  }
}
# Kubernetes
resource "google_container_cluster" "gke-cluster" {
  name = var.gke_name
  network = var.gke_nw
  location = var.region
  initial_node_count = var.gke_node_count
}
