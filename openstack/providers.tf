terraform {
  required_version = ">= 1.6.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.53.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  user_name   = "s22berti"
  tenant_name = "fila3-terraform-03"
  auth_url    = "https://openstack-enseignement.imt-atlantique.fr:5000"
  region      = "imt-atlantique-br-ens"
}