resource "kubernetes_deployment_v1" "gb-frontend" {
  metadata {
    name = "frontend"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "guestbook"
        Tier = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          App = "guestbook"
          Tier = "frontend"
        }
      }
      spec {
        container {
          name  = "gb-frontend"
          image = docker_image.guestbook-frontend
          env {
            name = "GET_HOSTS_FROM"
            value = "dns"
          }
          resources {
            requests = {
              cpu = "100m"
              memory = "100Mi"
            }
          }
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      App = "guestbook"
      Tier = "frontend"
    }
  }
  spec {
    selector = {
      App = "guestbook"
      Tier = "frontend"
    }
    port {
      port = 8080
      target_port = 80
    }
    type = "LoadBalancer"
  }
}