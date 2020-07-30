#Backend Config
terraform {
  backend "gcs" {
    credentials = "core-waters-284316-892e73a3a61b.json"
    bucket = "tf-state-23p"
    prefix = "terraform/state"
  }
}

#resource "google_service_account" "gsa" {
#  account_id = var.gsa_name
#  project = "core-waters-284316"
#}

#resource "google_project_iam_member" "cloud-sql-client" {
#  project = var.project
#  role = "roles/cloudsql.client"
#  member = "serviceAccount:${google_service_account.gsa.email}"
#}

#resource "kubernetes_service_account" "ksa" {
#  metadata {
#    name = var.ksa_name
#   annotations = {
#      "iam.gke.io/gcp-service-account" = google_service_account.gsa.email
#    }
#  }
#}

#resource "google_service_account_iam_binding" "gke_gsa_ksa_binding" {
#  service_account_id = google_service_account.gsa.name
#  role = "roles/iam.workloadIdentityUser"
#  members = [
#    "serviceAccount:${var.project}.svc.id.goog[default/${var.ksa_name}]"
#  ]
#}

# Kubernetes
resource "google_container_cluster" "gke-cluster" {
  provider = google
  name = var.gke_name
  network = var.gke_nw
  location = var.region
  initial_node_count = var.gke_node_count
  private_cluster_config {
    enable_private_nodes = false
    enable_private_endpoint = false
  }
  node_config {
  
  }
  provisioner "local-exec"{
    command = "gcloud container clusters get-credentials ${self.name} --region ${var.region} --project ${var.project}"
  }
  provisioner "local-exec"{
    command = "kubectl create -f ../k8s/d_Pod.yml"
  }
  provisioner "local-exec"{
    command = "kubectl create -f ../k8s/s_Cluster.yml"
  }
  provisioner "local-exec"{
    command = "kubectl create -f ../k8s/s_NodePort.yml"
  }
  provisioner "local-exec"{
    command = "kubectl get nodes -o wide"
  }  
  
}


#Firewall rules
resource "google_compute_firewall" "default" {
  name    = "p23-external-access"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["${var.app_port}"]
  }
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
  password = random_password.pwd.result
}

resource "random_password" "pwd" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    user_id = "p23_${google_sql_user.MySql.instance}"
  }
  byte_length = 4
}

