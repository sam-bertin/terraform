output "cluster_name" {
  value = data.google_container_cluster.my_cluster.name
}

output "cluster_location" {
  value = data.google_container_cluster.my_cluster.location
}

output "cluster_endpoint" {
  value = data.google_container_cluster.my_cluster.endpoint
}

output "cluster_master_version" {
  value = data.google_container_cluster.my_cluster.master_version
}
