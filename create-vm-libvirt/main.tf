variable "domain"   { default = "example.local" }
variable "hostname"   { default = "debian" }

resource "libvirt_pool" "pool" {
  name = "pool"
  type = "dir"
  path = "/home/pool"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "os_image_debian" {
  name   = "os_image_debian"
  pool   = "pool"
  # source = https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
  source = "/home/pool/debian-12-genericcloud-amd64.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "os_volume_resized" {
  name           = "os_volume_resized"
  base_volume_id = libvirt_volume.os_image_debian.id
  pool           = "pool"
  # size 50GB in bytes
  size           = 53687091200
}

data "template_file" "user_data" {
  template       = file("${path.module}/cloud_init.cfg")
  
    vars = {
    domain   = var.domain
    hostname = var.hostname
    fqdn     = join(".", [var.hostname, var.domain])
    }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "cloudinit_with_resize" {
  name           = "commoninit_resized.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_volume.os_volume_resized.pool
}

# Create the machine
resource "libvirt_domain" "debian" {
  name   = "debian"
  memory = "2048"
  vcpu   = 1
  autostart = true
  cloudinit = libvirt_cloudinit_disk.cloudinit_with_resize.id

  network_interface {
   # network_id     = libvirt_network.net1.id
    network_name   = "default"
    wait_for_lease = true

  }
  
  disk {
    volume_id = libvirt_volume.os_volume_resized.id
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


# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
output "ip" {
  value = libvirt_domain.debian.network_interface[0].addresses[0]
}
