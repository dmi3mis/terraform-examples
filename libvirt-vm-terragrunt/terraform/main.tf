
# Чтение публичного SSH ключа
locals {
  ssh_public_key = file( var.ssh_public_key )
}



# Пул для томов
resource "libvirt_pool" "vmspool" {
  name = var.pool_name
  type = "dir"
  path = var.pool_path
}

# Объем для базового образа
resource "libvirt_volume" "base" {
  name   = "base-image.qcow2"
  pool   = libvirt_pool.vmspool.name
  source = var.base_image_path
  format = "qcow2"
}

resource "libvirt_network" "network" {
    name      = var.network_name
    mode      = "nat"
    addresses = var.network_range
    autostart = true
    dhcp {
      enabled = false
    }
}



module "vms" {
  for_each = var.vms_config

  source      = "./modules/libvirt-vm"
  vm_name     = each.key
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
