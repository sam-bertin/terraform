terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

### Docker resources

## Images 

resource "docker_image" "redis" {
  name = "redis:alpine"
}

resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}

resource "docker_image" "vote1" {
  name = "vote1"
  build {
    context = "../../voting-services/vote"
  }
}

resource "docker_image" "vote2" {
  name = "vote2"
  build {
    context = "../../voting-services/vote"
  }
}

resource "docker_image" "result" {
  name = "result"
  build {
    context = "../../voting-services/result"
  }
}

resource "docker_image" "worker" {
  name = "worker"
  build {
    context = "../../voting-services/worker"
  }
}

resource "docker_image" "nginx" {
  name = "nginx"
  build {
    context = "../../voting-services/nginx"
  }
}

## Networks

resource "docker_network" "front_tier" {
  name = "front-tier"
}

resource "docker_network" "back_tier" {
  name = "back-tier"
}

## Volumes 

resource "docker_volume" "db_data" {
  name = "db-data"
}

## Containers

resource "docker_container" "redis" {
  name  = "redis"
  image = docker_image.redis.image_id
  networks_advanced {
    name = docker_network.back_tier.name
  }
}

resource "docker_container" "db" {
  name  = "db"
  image = docker_image.postgres.image_id
  env = [
    "POSTGRES_PASSWORD=postgres"
  ]
  # volumes {
  #   host_path      = "./healthchecks"
  #   container_path = "/healthchecks"
  # }
  volumes {
    container_path = "/var/lib/postgresql/data"
    volume_name    = docker_volume.db_data.name
  }
  networks_advanced {
    name = docker_network.back_tier.name
  }
}

resource "docker_container" "vote1" {
  name       = "vote1"
  image      = docker_image.vote1.image_id
  depends_on = [docker_container.redis]
  networks_advanced {
    name = docker_network.front_tier.name
  }
  networks_advanced {
    name = docker_network.back_tier.name
  }
}

resource "docker_container" "vote2" {
  name       = "vote2"
  image      = docker_image.vote2.image_id
  depends_on = [docker_container.redis]
  networks_advanced {
    name = docker_network.front_tier.name
  }
  networks_advanced {
    name = docker_network.back_tier.name
  }
}

resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.image_id
  ports {
    internal = 8000
    external = 8000
  }
  depends_on = [
    docker_container.vote1,
    docker_container.vote2,
  ]
  networks_advanced {
    name = docker_network.front_tier.name
  }
}

resource "docker_container" "result" {
  name  = "result"
  image = docker_image.result.image_id
  ports {
    internal = 80
    external = 5050
  }
  depends_on = [docker_container.db]
  networks_advanced {
    name = docker_network.front_tier.name
  }
  networks_advanced {
    name = docker_network.back_tier.name
  }
}

resource "docker_container" "worker" {
  name  = "worker"
  image = docker_image.worker.image_id
  depends_on = [docker_container.db,
  docker_container.redis]
  networks_advanced {
    name = docker_network.back_tier.name
  }
}

output "result_ip" {
  value       = docker_container.result.network_data[0].ip_address
  description = "IP address of the 'result' container"
}

output "result_port" {
  value       = docker_container.result.ports[0].external
  description = "External port of the 'result' container"
}

output "nginx_ip" {
  value       = docker_container.nginx.network_data[0].ip_address
  description = "IP address of the 'nginx' container"
}

output "nginx_port" {
  value       = docker_container.nginx.ports[0].external
  description = "External port of the 'nginx' container"
}
