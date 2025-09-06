
# Чтение публичного SSH ключа
locals {
  ssh_public_key = file("~/.ssh/id_ecdsa.pub")
}



# Пул для томов
resource "libvirt_pool" "vmspool" {
  name = "vms-pool"
  type = "dir"
  path = "/var/lib/libvirt/images/vms/"
}

# Объем для базового образа
resource "libvirt_volume" "base" {
  name   = "base-image"
  pool   = libvirt_pool.vmspool.name
  source = var.base_image_path
  format = "qcow2"
}

resource "libvirt_network" "network" {
    name      = "nat"
    mode      = "nat"
    addresses = ["192.168.123.0/24"]
    dhcp {
      enabled = false
    }
}


locals {
  vms_config = {
    "host1" = { vcpus = 2, memory = 2048, ipaddresses = ["192.168.123.10"], macaddress = "52:54:00:00:00:10" }
    "fs1" =   { vcpus = 4, memory = 4096, ipaddresses = ["192.168.123.11"], macaddress = "52:54:00:00:00:11" }
    "web1" =  { vcpus = 1, memory = 1024, ipaddresses = ["192.168.123.12"], macaddress = "52:54:00:00:00:12" }
  }
}

module "vms" {
  for_each = local.vms_config
  source      = "./modules/libvirt-vm"
  vm_name     = each.key
  vm_domain   = "example.com"
  vcpus       = each.value.vcpus
  memory      = each.value.memory
  vm_ipaddresses = each.value.ipaddresses
  vm_macaddress = each.value.macaddress
  base_image  = libvirt_volume.base.id
  pool_name   = libvirt_pool.vmspool.name
  depends_on  = [libvirt_pool.vmspool]
  network_name = libvirt_network.network.name
  ssh_public_key = local.ssh_public_key
}
