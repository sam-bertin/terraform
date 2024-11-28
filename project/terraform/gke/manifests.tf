resource "kubernetes_manifest" "db_data_pvc" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/db-data-pvc.yaml"))
}

resource "kubernetes_manifest" "pgsql_deployment" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/pgsql-deployment.yaml"))
}

resource "kubernetes_manifest" "pgsql_service" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/pgsql-service.yaml"))
}

resource "kubernetes_manifest" "redis_deployment" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/redis-deployment.yaml"))
}

resource "kubernetes_manifest" "redis_service" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/redis-service.yaml"))
}

resource "kubernetes_manifest" "result_deployment" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/result-deployment.yaml"))
}

resource "kubernetes_manifest" "result_service" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/result-service.yaml"))
}

resource "kubernetes_manifest" "vote1_deployment" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/vote-deployment.yaml"))
}

resource "kubernetes_manifest" "vote1_service" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/vote-service.yaml"))
}

resource "kubernetes_manifest" "vote2_deployment" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/vote-deployment.yaml"))
}

resource "kubernetes_manifest" "vote2_service" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/vote-service.yaml"))
}

resource "kubernetes_manifest" "worker_deployment" {
  manifest = yamldecode(file("/home/sabertin/terraform/project/terraform-project/k8s-manifests/worker-deployment.yaml"))
}
