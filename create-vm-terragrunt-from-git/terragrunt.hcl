terraform {
  source = "git::git@github.com:dmi3mis/terraform-examples.git//libvirt-vm-terragrunt//terraform"
  # source = "../libvirt-vm-terragrunt/terraform"
}

# Параметры для development
inputs = {
  #libvirt_uri = "qemu+ssh://dev-user@dev-libvirt-host/system"
  libvirt_uri  = "qemu:///system"

  vms_config   = {
    "alse183.astralinux.test"  = { vcpus = 2, memory = 4096, ipaddresses = ["192.168.105.10"], macaddress = "52:54:00:00:05:10" }
    #"fs1-fromgit.astralinux.test"    = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.105.11"], macaddress = "52:54:00:00:05:11" }
    # "web1-fromgit.astralinux.test"   = { vcpus = 1, memory = 1024, ipaddresses = ["192.168.105.12"], macaddress = "52:54:00:00:05:12" }
  }

  pool_name       = "fromgit"
  pool_path       = "/var/lib/libvirt/images/vms-fromgit/"

 
  # You can download image in advance and place it at default path
  # sudo wget -O /var/lib/libvirt/images/alse-gui-1.8.3-max-cloudinit-mg15.8.0-amd64.qcow2 https://registry.astralinux.ru/artifactory/mg-generic/alse/cloudinit/alse-gui-1.8.3-max-cloudinit-mg15.8.0-amd64.qcow2
  # Check image format with this command. We assert image will be in qcow2 format on qemu-kvm and have cloud-init inside.
  # sudo qemu-img info /var/lib/libvirt/images/alse-gui-1.8.3-max-cloudinit-mg15.8.0-amd64.qcow2
  # Or we can download image on the fly every time we use `terraform apply`.
  #base_image_path = "https://registry.astralinux.ru/artifactory/mg-generic/alse/cloudinit/alse-gui-1.8.3-max-cloudinit-mg15.8.0-amd64.qcow2"
  base_image_path = "/var/lib/libvirt/images/alse-gui-1.8.3-max-cloudinit-mg15.8.0-amd64.qcow2"
  vm_disk_size    =  10 * 1024 * 1024 * 1024 # 10GB
  network_name    = "fromgit"
  network_range   = ["192.168.105.0/24"]
  environment     = "fromgit"
  ssh_public_key  = "~/.ssh/id_ecdsa.pub"
}