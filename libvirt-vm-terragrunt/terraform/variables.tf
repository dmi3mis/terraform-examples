variable "libvirt_uri" {
  description = "URI для подключения к libvirt хосту"
  type        = string
  default     = "qemu:///system"
}

variable "vms_config" {
  description = "Конфигурация виртуальных машин"
  type = map(object({
    vcpus       = number
    memory      = number
    ipaddresses = list(string)
    macaddress = string
  }))
  default = {
    "host1.company.com" = { vcpus = 2, memory = 2048, ipaddresses = ["192.168.123.10"], macaddress = "52:54:00:00:00:10" }
    #"fs1.company.com" =   { vcpus = 4, memory = 4096, ipaddresses = ["192.168.123.11"], macaddress = "52:54:00:00:00:11" }
    #"web1.company.com" =  { vcpus = 1, memory = 1024, ipaddresses = ["192.168.123.12"], macaddress = "52:54:00:00:00:12" }
  }
}

variable "pool_name" {
  description = "vm pool name"
  type        = string
  default     = "vms-pool"
}

variable "pool_path" {
  description = "vm disk pool path"
  type        = string
  default     = "/var/lib/libvirt/images/vms/"
}

variable "vm_disk_size" {
  description = "Размер диска для VM (в байтах)"
  type        = number
  default     = 10737418240 # 10GB
}

# Образ ОС (замените на путь к вашему образу)
variable "base_image_path" {
  description = "Путь к базовому образу"
  type        = string
  default     = "/var/lib/libvirt/images/debian-12-genericcloud-amd64.qcow2"
}

variable "network_name" {
  description = "Network name"
  type        = string
  default     = "nat-net"
}


variable "network_range" {
  description = "Network range"
  type        = list
  default     = ["192.168.123.0/24"]
}

variable "ssh_public_key" {
  description = "Публичный SSH ключ"
  type        = string
}

variable "environment" {
  description = "Окружение (dev, qa, prod)"
  type        = string
  default     = "dev"
}
