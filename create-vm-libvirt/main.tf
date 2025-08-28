resource "libvirt_pool" "volpool" {
  name = "web-pool"
  type = "dir"
  path = "/var/lib/libvirt/images/web-vms/"
}

resource "libvirt_network" "nat1" {
    name      = "nat1"
    mode      = "nat"
    addresses = ["192.168.123.0/24"]

    dhcp {
      enabled = true
    }
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "base" {
  name           = "debian-12-genericcloud-amd64.qcow2"
  pool           = libvirt_pool.volpool.name
  source         = var.base_image
  format         = "qcow2"
  depends_on     = [libvirt_pool.volpool]
}

resource "libvirt_volume" "web_disk" {
  count          = var.vm_count
  name           = "web-${count.index + 1}-disk.qcow2"
  base_volume_id = libvirt_volume.base.id
  pool           = libvirt_pool.volpool.name
  size           = var.vm_disk_size
  depends_on     = [libvirt_pool.volpool]
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "cloudinit" {
  count     = var.vm_count
  name      = "web-${count.index + 1}-cloudinit.iso"
  pool      = libvirt_pool.volpool.name
  user_data      = <<-EOF
    #cloud-config
    disable_root: 1
    hostname: web-${count.index + 1}
    ssh_pwauth: 0
    users:
      - name: kadm
        gecos: K adm
        homedir: /home/kadm
        groups: users, sudo
        shell: /bin/bash
        sudo: ["ALL=(ALL) NOPASSWD:ALL"]
        ssh_import_id:
          - gh:dmi3mis
        ssh-authorized-keys:
          - ${file("~/.ssh/id_ecdsa.pub")}
    package_update: true
    packages:
      - nginx
      - git
    runcmd:
      - [ systemctl, enable, --now, nginx ]
      - [ sh, -c, "echo Hello on $(hostname) > /var/www/html/index.nginx-debian.html" ]
    growpart:
      mode: auto
      devices: ['/']
  EOF

  network_config = <<-EOF
    #network-config
    version: 2
    ethernets:
      ens3:
        dhcp4: true
        nameservers:
          search: [ ${var.domain} ]
          addresses: [8.8.8.8, 8.8.4.4]
  EOF
  depends_on = [libvirt_pool.volpool]
}

# Create the machine
resource "libvirt_domain" "web_vm" {
  count  = var.vm_count
  name   = "web-${count.index + 1}"
  memory = var.vm_memory
  vcpu   = var.vm_vcpus
  autostart = true
  cloudinit = libvirt_cloudinit_disk.cloudinit[count.index].id

  network_interface {
    network_id     = libvirt_network.nat1.id
    wait_for_lease = true
  }    
#  network_interface {
#  network_id     = libvirt_network.default.id
#  network_name   = "default"
#  wait_for_lease = true
#
#}
  
  disk {
    volume_id = libvirt_volume.web_disk[count.index].id
  }

  # Volumes physical files are not removed during destroy
  # https://github.com/dmacvicar/terraform-provider-libvirt/issues/1000

  # Failed to remove storage pool because of remnant actual volume
  # https://github.com/dmacvicar/terraform-provider-libvirt/issues/1083

  depends_on=[libvirt_volume.web_disk]
  
  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }


  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

}


# Вывод IP адресов созданных машин
output "vm_ips" {
  value = {
    for vm in libvirt_domain.web_vm :
    vm.name => vm.network_interface[0].addresses[0]
  }
  description = "IP адреса созданных виртуальных машин"
}

output "vm_names" {
  value = [for vm in libvirt_domain.web_vm : vm.name]
  description = "Имена созданных виртуальных машин"
}