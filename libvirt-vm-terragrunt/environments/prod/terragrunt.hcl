# Конфигурация для production окружения
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../terraform"
}

# Параметры для production
inputs = {
  #libvirt_uri = "qemu+ssh://prod-user@prod-libvirt-host/system"
  libvirt_uri  = "qemu:///system"

  vms_config   = {
    "host1-prod.company.com" = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.102.10"], macaddress = "52:54:00:00:02:10" }
    "fs1-prod.company.com"   = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.102.11"], macaddress = "52:54:00:00:02:11" }
    "web1-prod.company.com"  = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.102.12"], macaddress = "52:54:00:00:02:12" }
  }
  
  pool_name       = "prod"
  pool_path       = "/var/lib/libvirt/images/vms-prod/"
  base_image_path = "/var/lib/libvirt/images/debian-12-genericcloud-amd64.qcow2"
  vm_disk_size    =  10737418240 # 10GB
  network_name    = "prod-net"
  network_range   = ["192.168.102.0/24"]
  environment     = "prod"
}