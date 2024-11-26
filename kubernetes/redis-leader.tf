module "redis-leader-deployment" {
  source = "./deployment/"

  metadata_name   = "redis-leader"
  label_app       = "redis"
  label_tier      = "backend"
  container_name  = "leader"
  container_image = "docker.io/redis:6.0.5"
  container_port  = 6379
}

resource "kubernetes_service_v1" "redis-leader" {
  metadata {
    name = "redis-leader"
    labels = {
      App = "redis"
      Tier = "backend"
    }
  }
  spec {
    selector = {
      App = "redis"
      Tier = "backend"
    }
    port {
      port = 6379
      target_port = 6379
    }
  }
}