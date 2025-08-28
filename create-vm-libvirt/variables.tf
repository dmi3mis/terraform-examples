variable "vm_count" {
  description = "Количество виртуальных машин"
  type        = number
  default     = 1
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

variable "base_image" {
  description = "Base image path"
  
  # We download image on the fly every time we `terraform apply`. It only 330M in size so it will fownload fast.
  # default     = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
  # You can download image in advance and place it at default path
  # sudo wget -O /var/lib/libvirt/images/debian-12-genericcloud-amd64.qcow2 https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
  # Check image format with this command
  # sudo qemu-img info /var/lib/libvirt/images/debian-12-genericcloud-amd64.qcow2
  default     = "/var/lib/libvirt/images/debian-12-genericcloud-amd64.qcow2"
}

variable "vm_disk_size" {
  description = "Размер диска для каждой VM (в байтах)"
  type        = number
  default     = 10737418240 # 10GB
}

variable "domain"   { default = "example.local" }
