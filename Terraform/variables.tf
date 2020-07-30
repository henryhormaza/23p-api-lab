#Cloud
variable "region" {
  type = string
  description = "Clodu Region"
}
variable "project" {
  type = string
  description = "Projec of Lab"
}
variable "gsa_name" {
  type = string
  description = "google service accont name"
}
variable "ksa_name" {
  type = string
  description = "kubernetes service account name"
}
variable "auth_file" {
  type = string
  description = "Cloud file with credentials"
}
#Backend
variable "stg_bucket_name" {
  type = string
  description = "Bucket used as backend"
}
variable "stg_storage_class" {
  type = string
  description = "type of storage"
}
#kubernetes
variable "gke_name" {
  type = string
  description = "Name for the kubernetes cluster"
}
variable "gke_nw" {
  type = string
  description = "Kubernetes engine network"
}
variable "gke_node_count" {
  type = string
  description = "Kubernetes initial nodes amount"
}
#Mysql instance
variable "mysql_version" {
  type = string
  description = "Mysql version"
}
variable "mysql_name" {
  type = string
  description = "Mysql instance name"
}
variable "mysql_tier" {
  type = string
  description = "Shape size"
}
variable "mysql_act_pol" {
  type = string
  description = "db_activation_policy: Intance will be always on for testing at lab"
}
variable "mysql_disk_autoresize" {
  type = bool
  description = "not needed to rezise automatically"
}
variable "mysql_disk_size" {
  type = number
  description = "db_disk_size"
}
variable "mysql_instance_access_cidr" {
  type = string
  description = "The IPv4 CIDR to provide access the database instance"
}
# database
variable db_name {
  type = string
  description = "Name of the database to create"
}
variable db_charset {
  description = "The charset for the default database"
  default = ""
}
variable db_user_name {
  description = "db username for this lab"
  default = "23people"
}
variable db_user_host {
  type = string
  description = "default user host"
  default = "23people"
}
variable db_user_password {
  type = string
  description = "db password for this lab"
  default = "23people"
}
variable app_port {
  type = string
  description = "public port for application"
  default = ""
}
variable fw_ingress_rule_name {
  type = string
  description = "ingress rule name"
  default = ""
}

# Output Vars
output MySql_instance_IP {
  description = "IP address of the master database instance"
  value = google_sql_database_instance.MySql.ip_address.0.ip_address
}
output db_user_password {
  description = "db password for this lab"
  value = google_sql_user.MySql.password
}
output db_user_name {
  description = "db password for this lab"
  value = google_sql_user.MySql.name
}
output db_name {
  description = "db password for this lab"
  value = google_sql_database.MySql_db.name
}