variable "zone" {
  description = "Yandex Cloud zone"
  type        = string
  default     = "ru-central1-a"
}

variable "vpc_cidr" {
  description = "CIDR для подсети"
  type        = string
  default     = "10.10.0.0/24"
}

variable "vm_name_prefix" {
  description = "Префикс имени виртуальных машин"
  type        = string
  default     = "TestIaC"
}

variable "instance_count" {
  description = "Сколько ВМ поднять под балансировщик"
  type        = number
  default     = 2
}

variable "vm_cores" {
  description = "vCPU cores"
  type        = number
  default     = 4
}

variable "vm_memory" {
  description = "RAM (GiB)"
  type        = number
  default     = 4
}

variable "vm_fraction" {
  description = "Core fraction (для бурстовых)"
  type        = number
  default     = 20
}

variable "disk_size_gb" {
  description = "Размер системного диска, GB"
  type        = number
  default     = 15
}

variable "trusted_cidrs" {
  description = "CIDRs, которым разрешен доступ (22/80)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "resource_tags" {
  description = "Общие labels для ресурсов"
  type        = map(string)
  default = {
    project     = "terraform-ansible"
    environment = "dev"
  }
}

variable "ssh_public_key_path" {
  description = "Путь к публичному SSH-ключу для метадаты"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "existing_network_id" {
  type = string
}
variable "existing_subnet_id" {
  type = string
}