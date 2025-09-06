terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

resource "libvirt_volume" "vm_disk" {
  name           = "${var.vm_name}-disk.qcow2"
  format         = "qcow2"
  base_volume_id = var.base_image
  size           = var.disk_size
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name      = "${var.vm_name}-cloudinit.iso"
  pool      = var.pool_name
  user_data = <<-EOF
    #cloud-config
    fqdn: "${var.vm_name}.${var.vm_domain}"
    hostname: ${var.vm_name}
    prefer_fqdn_over_hostname: true
    create_hostname_file: true
    users:
      - name: ubuntu
        ssh_import_id:
          - gh:dmi3mis
        ssh-authorized-keys:
          - ${var.ssh_public_key}
        sudo: ['ALL=(ALL) NOPASSWD:ALL']
        groups: sudo
        shell: /bin/bash
    packages:
      - nginx
    runcmd:
      - systemctl enable nginx
      - systemctl start nginx
  EOF
  network_config = <<-EOF
    #network-config
    version: 2
    ethernets:
      ens3:
        dhcp4: true
        nameservers:
          search: [ ${var.vm_domain} ]
          addresses: [8.8.8.8, 8.8.4.4]
  EOF
}

resource "libvirt_domain" "vm" {
  name   = var.vm_name
  memory = var.memory
  vcpu   = var.vcpus
  autostart = true
  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }
  depends_on=[libvirt_volume.vm_disk]
  network_interface {
    network_name = var.network_name
    # hostname       = "master"
    addresses      = var.vm_ipaddresses
    mac            = var.vm_macaddress
    wait_for_lease = true
  }

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