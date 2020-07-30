provider "google" {
  credentials = var.auth_file
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

