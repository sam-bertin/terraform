data "openstack_compute_keypair_v2" "os_kp" {
  name = "os-admin"
}

# Image to boot the VM. Predefined by Brest's team.
data "openstack_images_image_v2" "imta" {
  name        = "imta-ubuntu-24.04"
  most_recent = true
}

resource "openstack_compute_instance_v2" "wp_app" {
  name            = "wordpress-app"
  image_name      = data.openstack_images_image_v2.imta.name
  flavor_name     = "m1.medium"
  key_pair        = data.openstack_compute_keypair_v2.os_kp.name
  security_groups = [ "sg-open" ]
  network {
    name = "internal"
  }
}

# Floating IP
resource "openstack_networking_floatingip_v2" "wp_ip" {
  pool = "external"
}
resource "openstack_compute_floatingip_associate_v2" "wp_ip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.wp_ip.address
  instance_id = openstack_compute_instance_v2.wp_app.id
}

# Outputs
output "wp_floating_ip" {
  value       = openstack_networking_floatingip_v2.wp_ip.address
  description = "Floating IP associated to the VM"
}