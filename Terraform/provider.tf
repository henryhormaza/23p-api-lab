provider "google" {
  credentials = file(./core-waters-284316-892e73a3a61b.json)
  project     = var.project
  region      = var.region
}
#provider "google-beta" {
#  credentials = file(var.auth_file)
#  project     = var.project
#  region      = var.region
#}

#provider "kubernetes" {
#  
#}

provider "random" {

}

