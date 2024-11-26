module "redis-follower-deployment" {
  source = "./deployment/"

  metadata_name   = "redis-follower"
  label_app       = "redis"
  label_tier      = "backend"
  container_name  = "follower"
  container_image = "gcr.io/google_samples/gb-redis-follower:v2"
  container_port  = 6379
}

resource "kubernetes_service_v1" "redis-follower" {
  metadata {
    name = "redis-follower"
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
    }
  }
}