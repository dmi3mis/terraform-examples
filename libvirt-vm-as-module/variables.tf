variable "vm_count" {
  description = "Количество виртуальных машин"
  type        = number
  default     = 3
}

variable "vm_memory" {
  description = "Объем памяти для каждой VM (в MB)"
  type        = number
  default     = 2048
}

variable "vm_vcpus" {
  description = "Количество vCPU для каждой VM"
  type        = number
  default     = 2
}

variable "vm_disk_size" {
  description = "Размер диска для каждой VM (в байтах)"
  type        = number
  default     = 10737418240 # 10GB
}

# Образ ОС (замените на путь к вашему образу)
variable "base_image_path" {
  description = "Путь к базовому образу"
  type        = string
  default     = "/var/lib/libvirt/images/debian-12-genericcloud-amd64.qcow2"
}