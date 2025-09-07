# Конфигурация для QA окружения
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../terraform"
}

# Параметры для QA
inputs = {
  #libvirt_uri = "qemu+ssh://qa-user@qa-libvirt-host/system"
  libvirt_uri  = "qemu:///system"

  vms_config   = {
    "host1-qa.company.com"   = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.103.10"], macaddress = "52:54:00:00:03:10", password = "ubuntu" }
    "fs1-qa.company.com"     = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.103.11"], macaddress = "52:54:00:00:03:11", password = "ubuntu" }
    "web1-qa.company.com"    = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.103.12"], macaddress = "52:54:00:00:03:12", password = "ubuntu" }
  }

  pool_name       = "qa"
  pool_path       = "/var/lib/libvirt/images/vms-qa/"
  base_image_path = "/var/lib/libvirt/images/debian-12-genericcloud-amd64.qcow2"
  vm_disk_size    =  10 * pow(2, 30) # 10GB
  network_name    = "qa-net"
  network_range   = ["192.168.103.0/24"]
  environment     = "qa"

}