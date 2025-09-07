# Конфигурация для development окружения
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../terraform"
}

# Параметры для development
inputs = {
  #libvirt_uri = "qemu+ssh://dev-user@dev-libvirt-host/system"
  libvirt_uri  = "qemu:///system"

  vms_config   = {
    "host1-dev.company.com"  = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.101.10"], macaddress = "52:54:00:00:01:10" }
    "fs1-dev.company.com"    = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.101.11"], macaddress = "52:54:00:00:01:11" }
    "web1-dev.company.com"   = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.101.12"], macaddress = "52:54:00:00:01:12" }
  }

  pool_name       = "dev"
  pool_path       = "/var/lib/libvirt/images/vms-dev/"
  base_image_path = "/var/lib/libvirt/images/debian-12-genericcloud-amd64.qcow2"
  vm_disk_size    =  10737418240 # 10GB
  network_name    = "dev-net"
  network_range   = ["192.168.101.0/24"]
  environment     = "dev"
}