############################################
# Образ Ubuntu
############################################
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

############################################
# Сеть/подсеть: ИСПОЛЬЗУЕМ существующие
############################################
data "yandex_vpc_network" "net" {
  network_id = var.existing_network_id
}

data "yandex_vpc_subnet" "subnet_a" {
  subnet_id = var.existing_subnet_id
}

############################################
# SG: SSH(22) + HTTP(80).
############################################
resource "yandex_vpc_security_group" "web" {
  name       = "hexlet-sg-web"
  network_id = data.yandex_vpc_network.net.id
  labels     = var.resource_tags

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    port           = 22
    v4_cidr_blocks = var.trusted_cidrs
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    port           = 80
    v4_cidr_blocks = var.trusted_cidrs
  }

  egress {
    protocol       = "ANY"
    description    = "All outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################
# ВМ имена в нижнем регистре и уникальные
############################################
resource "yandex_compute_instance" "vm" {
  count       = var.instance_count
  name        = format("%s-%02d", lower(var.vm_name_prefix), count.index + 1)
  platform_id = "standard-v3"
  labels      = var.resource_tags

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-ssd"
      size     = var.disk_size_gb
    }
  }

  network_interface {
    subnet_id          = data.yandex_vpc_subnet.subnet_a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web.id]
  }

  metadata = {
    "ssh-keys" = "ubuntu:${file(pathexpand(var.ssh_public_key_path))}"
  }
}

############################################
# NLB (Target Group + Listener:80)
############################################
locals {
  tg_targets = [
    for inst in yandex_compute_instance.vm : {
      subnet_id = inst.network_interface[0].subnet_id
      address   = inst.network_interface[0].ip_address
    }
  ]
}

resource "yandex_lb_target_group" "app_group" {
  name      = "app-targets"
  region_id = "ru-central1"
  labels    = var.resource_tags

  dynamic "target" {
    for_each = local.tg_targets
    content {
      subnet_id = target.value.subnet_id
      address   = target.value.address
    }
  }
}

resource "yandex_lb_network_load_balancer" "app_lb" {
  name   = "app-lb"
  labels = var.resource_tags

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {}
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.app_group.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

############################################
# Ansible inventory.ini
############################################
resource "local_file" "ansible_inventory" {
  filename        = "${path.module}/../Ansible/inventories/prod/hostsTerraform.ini"
  file_permission = "0644"
  content = <<EOT
[web]
%{ for inst in yandex_compute_instance.vm ~}
${inst.name} ansible_host=${inst.network_interface[0].nat_ip_address} ansible_user=ubuntu
%{ endfor ~}

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=accept-new'
EOT
}