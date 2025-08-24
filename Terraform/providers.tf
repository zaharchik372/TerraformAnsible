terraform {
  required_version = ">= 1.7.1"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.150"
    }
  }
}

provider "yandex" {
  zone = var.zone
}
