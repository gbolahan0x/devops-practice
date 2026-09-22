resource "docker_network" "iac_lab" {
  name = "terraform-${var.environment}-network"
}

resource "docker_image" "nginx" {
  name         = "nginx:1.27-alpine"
  keep_locally = false
}

resource "docker_container" "nginx" {
  name  = "terraform-${var.environment}-nginx"
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.iac_lab.name
  }

  ports {
    internal = 80
    external = var.host_port
  }
}
