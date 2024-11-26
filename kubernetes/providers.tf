variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "5.6.0"
    }
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = ">= 2.23.0"
    }
    docker = {
        source  = "kreuzwerker/docker"
        version = "~> 3.0.2"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone = var.zone
  credentials = file("/home/sabertin/terraform/gcp/terraform-442812-a59d5f199fdf.json")
}

provider "docker" {
  registry_auth {
    address  = "europe-west9-docker.pkg.dev"
    username = "oauth2accesstoken"
    password = data.google_service_account_access_token.sa.access_token
  }
}

data "google_service_account_access_token" "sa" {
  target_service_account = "650084221978-compute@developer.gserviceaccount.com"
  scopes                 = [ "cloud-platform" ]
}

# Configure kubernetes provider with Oauth2 access token.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# This fetches a new token, which will expire in 1 hour.
data "google_client_config" "default" {}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}