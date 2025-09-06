output "vm_id" {
  description = "ID созданной виртуальной машины"
  value       = libvirt_domain.vm.id
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = libvirt_domain.vm.name
}

output "vm_ip" {
  description = "IP адрес виртуальной машины"
  value       = try(libvirt_domain.vm.network_interface[0].addresses[0], null)
}

output "disk_id" {
  description = "ID диска виртуальной машины"
  value       = libvirt_volume.vm_disk.id
}