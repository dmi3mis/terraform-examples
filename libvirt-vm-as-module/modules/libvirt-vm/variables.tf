variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "vm_domain" {
  description = "machine domain"
  type        = string
  default     = "example.com"
}

variable "vm_ipaddresses" {
  description = "Network interface IP address"
  type        = list
}

variable "vm_macaddress" {
  description = "Network interface MAC address"
  type        = string
}

variable "vcpus" {
  description = "Количество vCPU"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Объем оперативной памяти (в MB)"
  type        = number
  default     = 2048
}

variable "base_image" {
  description = "Путь к базовому образу"
  type        = string
}

variable "disk_size" {
  description = "Размер диска (в байтах)"
  type        = number
  default     = 10737418240 # 10GB
}

variable "pool_name" {
  description = "Имя пула томов"
  type        = string
}

variable "network_name" {
  description = "Имя сети"
  type        = string
  default     = "default"
}

variable "ssh_public_key" {
  description = "Публичный SSH ключ"
  type        = string
}