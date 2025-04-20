provider "docker" {
  host = "ssh://ubuntu@89.169.136.50:22"
}

provider "random" {}

resource "random_password" "mysql_root_password" {
  length  = 16
  special = true
}

resource "random_password" "mysql_user_password" {
  length  = 16
  special = true
}

resource "random_id" "container_suffix" {
  byte_length = 4
}

resource "docker_image" "mysql" {
  name = "mysql:8"
}

resource "docker_container" "mysql" {
  name  = "mysql_${random_id.container_suffix.hex}"
  image = docker_image.mysql.name
  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_user_password.result}",
    "MYSQL_ROOT_HOST=%"
  ]
}

output "mysql_container_name" {
  value     = docker_container.mysql.name
  sensitive = true
}