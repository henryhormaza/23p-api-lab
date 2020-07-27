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
# Mysql instance
resource "google_sql_database_instance" "MySql" {
  name = var.mysql_name
  project = var.project
  region = var.region
  database_version = var.mysql_version
  
  settings {
    tier = var.mysql_tier
    activation_policy = var.mysql_act_pol
    disk_autoresize = var.mysql_disk_autoresize
    disk_size = var.mysql_disk_size   
    backup_configuration {
      binary_log_enabled = true
      enabled = true
      start_time = "00:00"
    }   
    ip_configuration {
      ipv4_enabled = "true"
      authorized_networks {
        value = var.mysql_instance_access_cidr
      }
    }
  }
}

# MySql DB
resource "google_sql_database" "MySql_db" {
  name = var.db_name
  project = var.project
  instance = google_sql_database_instance.MySql.name
}

# MySql DB User
resource "google_sql_user" "MySql" {
  name = var.db_user_name
  project  = var.project
  instance = google_sql_database_instance.MySql.name
  host = var.db_user_host
  password = var.db_user_password
}


