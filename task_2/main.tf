terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.13"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
  }
}

provider "yandex" {
  service_account_key_file = "/home/ubuntu/.yc-keys/sa-key.json"
  cloud_id                = var.cloud_id
  folder_id               = var.folder_id
  zone                    = "ru-central1-a"
}

resource "yandex_compute_instance" "vm" {
  name        = "docker-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd84b1mojb8650b9luqd" # Ubuntu
      size     = 20
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/ubuntu/.ssh/id_ed25519.pub")}"
  }
}

output "vm_external_ip" {
  value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}